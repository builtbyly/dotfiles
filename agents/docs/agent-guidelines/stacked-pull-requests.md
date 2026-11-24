# Stacked Pull Requests

Use these rules after a pull-request stack has been requested.

## Authorization

Before choosing or installing a stacking tool, propose it and wait for approval. Identify the exact tool and verify its commands from the installed version.

## Published Stacks

Treat a stack as published from the first opened pull request until every pull request in the stack has landed or closed.

Append review fixes as new commits on the branch for the affected pull request. Do not amend or squash commits reviewers have seen.

Before synchronizing dependent branches, explain which published branches may be rewritten or force-pushed and obtain approval.

Do not synchronize a published stack solely to catch up with the main branch.

## Merge-Based Stacks

If an existing stack preserves ancestry with merge commits, continue using that workflow until the stack lands. Do not use commands that rebase or force-push its branches. Append fixes and publish them with a normal push.

The rebase and squash steps in [Git workflow](git-workflow.md#pushing) do not apply to a published stack.
