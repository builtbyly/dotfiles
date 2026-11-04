export type Snapshot = {
  // Repo name, plus the worktree's when in a linked one; null outside a repo.
  // Optional: a snapshot stored before this field existed lacks it
  location?: string | null
  branch: string | null
  model: string
  ctxPercent: number | null
  ctxTokens: number | null
  ctxWindow: number | null
  fiveHour: number | null
  sevenDay: number | null
  // When the session began, in $.clock.now() milliseconds, and its cost so far.
  // Optional: a snapshot stored before these fields existed lacks them
  startedAt?: number | null
  costUsd?: number | null
  // What the total grew by the last time it changed: the last call's cost
  costDeltaUsd?: number | null
}

declare module 'claude-code' {
  interface PluginState {
    'desktop-status': { snap: Snapshot | null }
  }
}
