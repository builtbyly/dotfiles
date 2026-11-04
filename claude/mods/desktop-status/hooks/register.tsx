import { atom, read, update } from 'claude-code'
import type {
  Color,
  EngineInterface,
  Register,
  RenderChildren,
  SessionContextUsage,
  SessionCost,
  SessionRateLimit,
} from 'claude-code'

// Muted scheme from ~/.claude/statusline-command.sh: greys for info, colour only
// for meaning. Greys are theme keys so they follow light/dark.
const PRIMARY: Color = 'text' // 252/250 repo, model
const MUTED: Color = 'inactive' // 245 branch, tokens, limits
const SEPARATOR: Color = 'subtle' // 240
const TEAL = '#5fafaf' // 73 context bar
const DIM_TEAL = '#5f8787' // 66 cost delta
const WARNING: Color = 'warning' // 178
const CRITICAL: Color = 'error' // 160

const snap = atom({ plugin: 'desktop-status', key: 'snap' } as const, null)

const basename = (path: string) => path.replace(/\/+$/, '').split('/').pop() ?? path

// The app already shows the folder, so name only the repo, plus the worktree when
// the session runs in a linked one: 'routing-api-backend · new-session-b88191'.
// The app's worktrees sit on 'claude/<worktree>', so a branch that only repeats
// the worktree's name is left out. Outside a repo there is nothing worth showing.
const location = (toplevel: string, commonDir: string, branch: string | null) => {
  const mainRoot = commonDir.replace(/\/\.git\/?$/, '')
  const repo = basename(mainRoot)
  if (toplevel === mainRoot) return { where: repo, branch }
  const worktree = basename(toplevel)
  const isRepeated = branch !== null && basename(branch) === worktree
  // The app's worktree names end in a random '-c8378e'; it only costs room
  const name = toplevel.includes('/.claude/worktrees/') ? worktree.replace(/-[0-9a-f]{6}$/, '') : worktree
  return { where: `${repo} · ${name}`, branch: isRepeated ? null : branch }
}

// 'claude-opus-5-5' → 'Opus 5.5', 'claude-sonnet-4-5-20250929[1m]' → 'Sonnet 4.5'
const modelName = (id: string) => {
  const m = /^claude-([a-z]+)-(\d+)(?:-(\d{1,2}))?(?:-\d{8})?(?:\[.*\])?$/.exec(id)
  if (!m || !m[1] || !m[2]) return id
  const family = m[1].charAt(0).toUpperCase() + m[1].slice(1)
  return m[3] ? `${family} ${m[2]}.${m[3]}` : `${family} ${m[2]}`
}

// The desktop app wraps a Text whatever its `wrap` prop, so a name too long for
// its row is cut by hand. The caps are what fits beside each row's right side at
// the app's usual width; only an unusually long name meets them.
const MAX_LOCATION = 54
const MAX_BRANCH = 68
const cut = (text: string, room: number) => (text.length <= room ? text : `${text.slice(0, room - 1)}…`)

const limit = (limits: SessionRateLimit[], kind: string) =>
  limits.find(l => l.kind === kind)?.percentUsed ?? null

const ctxColor = (used: number): Color => (used >= 85 ? CRITICAL : used >= 60 ? WARNING : TEAL)

// The context bar as a thin rounded pill. An SVG cannot read the theme, so the
// track is a translucent grey that sits on light and dark alike, and the fill
// takes the hex of the same 73 / 178 / 160 steps
const BAR_WIDTH = 72
const BAR_HEIGHT = 6
const barSvg = (used: number) => {
  const fill = used >= 85 ? '#d70000' : used >= 60 ? '#d7af00' : TEAL
  const r = BAR_HEIGHT / 2
  const w = used <= 0 ? 0 : Math.max(BAR_HEIGHT, Math.round((Math.min(used, 100) * BAR_WIDTH) / 100))
  return (
    `<svg xmlns="http://www.w3.org/2000/svg" width="${BAR_WIDTH}" height="${BAR_HEIGHT}" viewBox="0 0 ${BAR_WIDTH} ${BAR_HEIGHT}">` +
    `<rect width="${BAR_WIDTH}" height="${BAR_HEIGHT}" rx="${r}" fill="#808080" fill-opacity="0.28"/>` +
    (w > 0 ? `<rect width="${w}" height="${BAR_HEIGHT}" rx="${r}" fill="${fill}"/>` : '') +
    `</svg>`
  )
}
// How long the session has run: '42m', '3h 05m', '7d 02h'. Days keep a week-old
// session as short as an hour-old one
const elapsed = (ms: number) => {
  const minutes = Math.max(0, Math.floor(ms / 60000))
  const pad = (n: number) => String(n).padStart(2, '0')
  if (minutes < 60) return `${minutes}m`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return `${hours}h ${pad(minutes % 60)}m`
  return `${Math.floor(hours / 24)}d ${pad(hours % 24)}h`
}

const limitColor = (used: number): Color => (used >= 90 ? CRITICAL : used >= 70 ? WARNING : MUTED)

const refresh = async (
  $: EngineInterface,
  usage?: { context: SessionContextUsage; rateLimits: SessionRateLimit[]; cost?: SessionCost },
) => {
  const cwd = await $.session.cwd()
  const git = (args: string[]) =>
    $.process
      .run(['git', ...args], { cwd, env: { GIT_OPTIONAL_LOCKS: '0' } })
      .then(r => (r.exitCode === 0 ? r.stdout.trim() : null))
      .catch(() => null)

  const roots = await git(['rev-parse', '--path-format=absolute', '--show-toplevel', '--git-common-dir'])
  const [toplevel, commonDir] = roots?.split('\n') ?? []
  const head = toplevel && commonDir ? (await git(['symbolic-ref', '--short', 'HEAD'])) || null : null
  const { where, branch } =
    toplevel && commonDir ? location(toplevel, commonDir, head) : { where: null, branch: null }

  // A measure event has no 'startedAt', so the plain call (it costs nothing) adds it
  const full = await $.session.usage()
  const { context, rateLimits, cost } = usage ?? full
  const model = modelName(await $.session.model())

  // As in statusline-command.sh: a change in the total is the last call's cost,
  // and it stays shown until the total changes again
  const costUsd = cost?.usd ?? null
  await update($, snap, prev => ({
    location: where,
    branch,
    model,
    ctxPercent: context.percent ?? null,
    ctxTokens: context.tokens ?? null,
    ctxWindow: context.window ?? null,
    fiveHour: limit(rateLimits, 'five_hour'),
    sevenDay: limit(rateLimits, 'seven_day'),
    startedAt: full.startedAt,
    costUsd,
    costDeltaUsd:
      costUsd !== null && prev?.costUsd != null && Math.abs(costUsd - prev.costUsd) > 0.00001
        ? Math.max(0, costUsd - prev.costUsd)
        : (prev?.costDeltaUsd ?? null),
  }))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const started = await next(e)
    await refresh($).catch(() => {})
    return started
  })

  on('session.measure', async ($, e, next) => {
    const result = await next(e)
    await refresh($, e).catch(() => {})
    return result
  })

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    await refresh($).catch(() => {})
    return result
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    // The terminal already has statusline-command.sh; draw only in the desktop app
    if (e.surface !== 'desktop' || e.props.hasSurvey) return next(e)
    const s = await read($, snap)
    if (s === null) return next(e)

    const { Box, Svg, Text } = $.ui.resolve(e)
    const used = s.ctxPercent

    // Context pill and limits: '(====    ) 12%  5h 1%  7d 2%', each limit's label
    // dim and its figure coloured by how close it is
    const gauges = (
      <Box flexDirection="row" flexWrap="nowrap" alignItems="center" columnGap="sm">
        {used !== null ? (
          <Svg
            source={barSvg(used)}
            alt={`Context ${Math.round(used)}% used`}
            width={BAR_WIDTH}
            height={BAR_HEIGHT}
          />
        ) : null}
        <Text mono size="footnote">
          {used !== null ? (
            <Text color={ctxColor(used)} tabular>{`${Math.round(used)}%`}</Text>
          ) : null}
          {s.fiveHour !== null ? (
            <Text>
              <Text color={SEPARATOR}>{'  5h '}</Text>
              <Text color={limitColor(s.fiveHour)} tabular>{`${Math.round(s.fiveHour)}%`}</Text>
            </Text>
          ) : null}
          {s.sevenDay !== null ? (
            <Text>
              <Text color={SEPARATOR}>{'  7d '}</Text>
              <Text color={limitColor(s.sevenDay)} tabular>{`${Math.round(s.sevenDay)}%`}</Text>
            </Text>
          ) : null}
        </Text>
      </Box>
    )
    // Run time and cost before the model: '7d 02h  $4.29 (+$0.12)  Opus 5.5'. The
    // clock read redraws it as time passes
    const ran = s.startedAt ? elapsed((await $.clock.now()) - s.startedAt) : null
    const cost = s.costUsd != null ? `$${s.costUsd.toFixed(2)}` : null
    const d = s.costDeltaUsd ?? 0
    const delta = d >= 0.005 ? ` (+$${d.toFixed(2)})` : d > 0 ? ' (+<$0.01)' : null
    const model = (
      <Text mono size="footnote">
        {ran ? <Text color={MUTED} tabular>{`${ran}  `}</Text> : null}
        {cost ? <Text color={MUTED} tabular>{cost}</Text> : null}
        {cost && delta ? <Text color={DIM_TEAL} tabular>{delta}</Text> : null}
        {cost ? '  ' : null}
        <Text color={PRIMARY}>{s.model}</Text>
      </Text>
    )
    const row = (left: RenderChildren, right: RenderChildren) => (
      <Box flexDirection="row" flexWrap="nowrap" justifyContent="space-between" columnGap="md" width="100%">
        <Box flexShrink={1} minWidth={0}>
          {left}
        </Box>
        <Box flexShrink={0}>{right}</Box>
      </Box>
    )

    // Outside a repo there is no 'where': one row of model and gauges
    if (!s.location) return row(model, gauges)

    // The repo bold, the worktree after it in regular weight, so the two read
    // as one name with the repo first
    const [repo = s.location, worktree] = s.location.split(' · ')

    // Two rows by design: where you are, and what it costs. Row 1 the repo and
    // worktree beside the gauges, row 2 the branch beside run time, cost and model
    return (
      <Box flexDirection="column" width="100%">
        {row(
          <Text mono size="footnote" color={PRIMARY}>
            <Text weight="semibold">{cut(repo, MAX_LOCATION)}</Text>
            {worktree ? <Text>{` · ${cut(worktree, Math.max(8, MAX_LOCATION - repo.length - 3))}`}</Text> : null}
          </Text>,
          gauges,
        )}
        {row(
          s.branch ? (
            <Text mono size="footnote" color={MUTED}>
              {cut(s.branch, MAX_BRANCH)}
            </Text>
          ) : null,
          model,
        )}
      </Box>
    )
  })
}
