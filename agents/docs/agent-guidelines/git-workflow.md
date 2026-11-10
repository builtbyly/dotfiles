# Git workflow

Use these rules for Git operations and repository workflow changes.

## Worktrees

Before creating a worktree, propose the worktree directory and branch names, then wait for user approval.

## Commits

Use short, single-sentence Conventional Commit messages.

## Pushing

When asked to commit and push:

1. If currently on the main branch, create a feature branch before pushing.
2. Rebase onto the main branch unless the user requests another base or strategy.
3. Inspect the commit history after rebasing.
4. Squash `wip` and `fixup` commits into the most logical commit before pushing.


## Preventing repeated mistakes

When asked to undo an AI-written change, determine whether its cause is already addressed by `AGENTS.md`. If the mistake is not obvious and no existing instruction covers it, suggest a preventive `AGENTS.md` change. Obtain permission before editing the instructions.
