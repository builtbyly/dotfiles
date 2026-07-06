# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  gradle-completion
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH=/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin
export PATH="/usr/local/pkg/bin/:$PATH"

# Add a local bin directory to the PATH
export PATH="$HOME/.local/bin:$PATH"

# Configure the fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias v=nvim
alias gn='git --no-pager'
alias gs='git status'
alias gw='./gradlew'
alias gdd='git diff | diff-so-fancy'

# Function for git diff with variable range and diff-so-fancy
gdf() {
  git diff "$1" | diff-so-fancy
}

alias gapf='git add --all && git commit --amend --no-edit && git push origin "$(git_current_branch)" --force-with-lease --force-if-includes'
alias gaaa='git add --all && git commit --amend --no-edit'
alias gdw="git diff --word-diff"
alias gdcaw="git diff --cached --word-diff"
alias glolr="git log HEAD...origin/master --oneline --left-right"

# git worktree aliases
alias gwt='git worktree'
alias gwtls='git worktree list'
alias gwtc='git worktree add'
alias gwtcpr='git worktree add --prune'
alias gwtcd='git worktree add --detach'
alias gwtcprd='git worktree add --prune --detach'
alias gwtr='git worktree remove'
alias gtwm='git worktree move'
alias gwtf='git worktree repair'
alias gwtpr='git worktree add --prune --detach -b pr-$(git rev-parse --short HEAD) origin/$(git rev-parse --abbrev-ref HEAD)'

alias l='eza -la --classify'
alias lt='eza -l --tree --only-dirs --level 2 --classify'
alias lg='eza -la --git --git-ignore'

alias d='docker'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'
alias dcl='docker-compose logs -f'
alias dcr='docker-compose run --rm'
alias dce='docker-compose exec'

alias sg='ast-grep'


# disk usage
alias du='du -h -d 1'
alias dud='du -h -d 0'
alias dudl='du -h -d 0 | sort -hr'
alias dfh="df -h / | awk 'NR==2{print \"Used: \"\$3\" / \"\$2\" — Available: \"\$4}'"

alias navlint='./gradlew :navigation:navigation:ktlintFormat :navigation:navigation-collaboration-tests:ktlintFormat'
alias navdetekt='./gradlew :navigation:navigation:detekt :navigation:navigation-collaboration-tests:detekt'

# pnpm
export PNPM_HOME="/Users/lainovic/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias as-tree='tree --fromfile'
alias as-tree-android='tree --fromfile -I "build|gradle|gradlew|gradlew.bat|local.properties|settings.gradle"'
alias t='tree -L 2'

# Android
export PATH=$PATH:/usr/local/pkg/android-sdk/platform-tools
export PATH=$PATH:/usr/local/pkg/android-sdk/cmdline-tools
export PATH=$PATH:/usr/local/pkg/android-sdk/emulator
export PATH=$PATH:/usr/local/pkg/android-sdk/tools

# Java
export JAVA_HOME=/usr/local/pkg/java/adoptopenjdk17-bin

# PostgreSQL CLI
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

# Rust
source "$HOME/.cargo/env"

# atuin
. "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"

# Initialize zoxide
eval "$(zoxide init zsh)"

# Added by Antigravity
export PATH="/Users/lainovic/.antigravity/antigravity/bin:$PATH"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/go/bin
