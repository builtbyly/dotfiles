# Agent instructions

This repository contains reusable agent instructions and supporting guidance for software-engineering work.

## Universal guardrails

- Keep changes unstaged unless explicitly asked to stage or commit them.
- Create pull requests and issue-tracker tickets only when explicitly requested.
- Human review is required for all AI-generated or AI-assisted code.

## Plan mode

- Keep plans extremely concise; fragments are acceptable.
- End each plan with `Unresolved questions:`. Omit the section when there are none.

## Task-specific guidance

- **Git operations, commits, branches, pushes, pull requests, or reverting AI-written work:** read [Git workflow](docs/agent-guidelines/git-workflow.md).
- **Committing AI-assisted work, handling DCO checks, or writing AI disclosures:** read [AI attribution and signoff](docs/agent-guidelines/ai-attribution.md).
- **Creating or reviewing code, planning a large change, or organizing a pull request:** read [Changes and review](docs/agent-guidelines/changes-and-review.md).
- **Writing a script:** read [Scripting](docs/agent-guidelines/scripting.md).
- **Writing or editing prose:** read [Prose style](docs/agent-guidelines/prose-style.md).
- **Writing or editing technical documentation:** read [Technical writing](docs/agent-guidelines/technical-writing.md) and [Prose style](docs/agent-guidelines/prose-style.md).
