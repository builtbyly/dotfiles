#!/bin/sh
# Claude Code status line - muted scheme: greys for info, colour only for meaning.
#
# Left:  <dir (bold 252)> <git-branch (245)>
# Right: <model (250)> <ctx bar+% (teal 73; 178 >=60%; 160 >=85%)> <tokens (245)>
#        <cost (245)> <delta (dim teal 66)> <rate-limits (245; 178 >=70%; 160 >=90%)>
# Separator: 240
#
# Color references (256-colour):
#   252/250  light greys — directory / model
#   245      mid grey    — branch, tokens, cost, rate limits (default)
#   240      dark grey   — separator
#   73       teal        — context bar (normal)
#   66       dim teal    — cost delta
#   178      yellow      — warning
#   160      red         — critical

input=$(cat)

# --- Directory ---------------------------------------------------------------
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
  home="$HOME"
  short_dir=$(echo "$cwd" | sed "s|^$home|~|")
else
  short_dir=""
fi

# --- Git branch (GIT_OPTIONAL_LOCKS=0 skips optional lock files) -------------
branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
fi

# --- Claude-specific data ----------------------------------------------------
model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# --- Build left segment: dir + git branch ------------------------------------
left=""

# Directory: bold 252
if [ -n "$short_dir" ]; then
  left=$(printf "\033[1;38;5;252m%s\033[0m" "$short_dir")
fi

# Git branch: 245 with branch glyph
if [ -n "$branch" ]; then
  left="$left $(printf "\033[38;5;245m\xef\x9c\xa8 %s\033[0m" "$branch")"
fi

# --- Build right segment: model + context + rate limits ----------------------
right=""

# Model: 250
if [ -n "$model" ]; then
  right=$(printf "\033[38;5;250m%s\033[0m" "$model")
fi

# Context remaining: teal 066 (matches p10k time segment colour)
if [ -n "$remaining" ]; then
  used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
  [ -z "$used" ] && used=$(awk "BEGIN{print 100-$remaining}")
  width=10
  filled=$(awk "BEGIN{f=int($used*$width/100+0.5); if(f>$width)f=$width; if(f<0)f=0; print f}")
  bar=""; i=0
  while [ "$i" -lt "$width" ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}█"; else bar="${bar}░"; fi
    i=$((i + 1))
  done
  # Bar colour: teal 73 <60%, yellow 178 <85%, red 160 otherwise
  barcolor=73
  if [ "$(awk "BEGIN{print ($used>=85)}")" = "1" ]; then barcolor=160
  elif [ "$(awk "BEGIN{print ($used>=60)}")" = "1" ]; then barcolor=178; fi
  # Token counts: used tokens / window size, formatted as k (or M for >=1M)
  tok_used=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
  tok_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
  tokens=""
  if [ -n "$tok_used" ] && [ -n "$tok_size" ] && [ "$tok_size" != "0" ]; then
    tokens=$(awk -v u="$tok_used" -v s="$tok_size" '
      function fmt(n,   r) {
        if (n >= 1000000) { r = sprintf("%.1f", n/1000000); sub(/\.0$/, "", r); return r "M" }
        if (n >= 1000)    { r = sprintf("%.0f", n/1000); return r "k" }
        return sprintf("%d", n)
      }
      BEGIN { printf " (%s/%s)", fmt(u), fmt(s) }')
  fi
  ctx=$(printf "\033[38;5;%sm%s %.0f%%\033[0m" "$barcolor" "$bar" "$used")
  [ -n "$tokens" ] && ctx="$ctx$(printf "\033[38;5;245m%s\033[0m" "$tokens")"
  right="$right ${ctx}"
fi

# Session cost with per-update delta (state kept in a per-session temp file)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
if [ -n "$cost" ]; then
  sid=$(echo "$input" | jq -r '.session_id // empty')
  [ -z "$sid" ] && sid="default"
  sfile="${TMPDIR:-/tmp}/claude-statusline-cost-${sid}"
  last_total=""; last_delta=""
  [ -f "$sfile" ] && read -r last_total last_delta < "$sfile" 2>/dev/null
  delta=0
  if [ -z "$last_total" ]; then
    { printf '%s 0\n' "$cost" > "$sfile.tmp" && mv "$sfile.tmp" "$sfile"; } 2>/dev/null
  else
    changed=$(awk -v a="$cost" -v b="$last_total" 'BEGIN{d=a-b; if(d<0)d=-d; print (d>0.00001)?1:0}')
    if [ "$changed" = "1" ]; then
      delta=$(awk -v a="$cost" -v b="$last_total" 'BEGIN{d=a-b; if(d<0)d=0; printf "%.6f", d}')
      { printf '%s %s\n' "$cost" "$delta" > "$sfile.tmp" && mv "$sfile.tmp" "$sfile"; } 2>/dev/null
    else
      delta="${last_delta:-0}"
    fi
  fi
  cost_seg=$(printf "\033[38;5;245m\$%.2f\033[0m" "$cost")
  dclass=$(awk -v d="$delta" 'BEGIN{ if (d>=0.005) print "show"; else if (d>0) print "tiny"; else print "none" }')
  case "$dclass" in
    show) cost_seg="$cost_seg $(printf "\033[38;5;66m(+\$%.2f)\033[0m" "$delta")" ;;
    tiny) cost_seg="$cost_seg $(printf "\033[38;5;66m(+<\$0.01)\033[0m")" ;;
  esac
  right="$right ${cost_seg}"
fi

# Rate limits: 245 default; 178 >=70%; 160 >=90% (each window independent)
limit_color() {
  awk -v p="$1" 'BEGIN{ if (p>=90) print 160; else if (p>=70) print 178; else print 245 }'
}
if [ -n "$five" ] || [ -n "$week" ]; then
  limits=""
  if [ -n "$five" ]; then
    limits=$(printf "\033[38;5;%sm5h:%.0f%%\033[0m" "$(limit_color "$five")" "$five")
  fi
  if [ -n "$week" ]; then
    limits="${limits} $(printf "\033[38;5;%sm7d:%.0f%%\033[0m" "$(limit_color "$week")" "$week")"
  fi
  right="$right $limits"
fi

# --- Combine with a dark grey separator (240) between left and right ---------
if [ -n "$left" ] && [ -n "$right" ]; then
  printf "%s  \033[38;5;240m|\033[0m  %s\n" "$left" "$right"
elif [ -n "$left" ]; then
  printf "%s\n" "$left"
elif [ -n "$right" ]; then
  printf "%s\n" "$right"
fi
