# dotfiles

This repository tracks configuration and reusable agent instructions for:

- `agents/`
- `nvim/`
- `zshrc/`

## Agent instructions

`agents/AGENTS.md` contains the project-wide agent guardrails and links to task-specific guidance under `agents/docs/agent-guidelines/`:

- `ai-attribution.md` — AI disclosure and DCO signoff
- `atlassian-workflow.md` — Jira and Confluence operations
- `changes-and-review.md` — code changes, review passes, and pull-request organization
- `context-management.md` — compaction, drift detection, and handoffs
- `git-workflow.md` — commits, branches, rebasing, and pushes
- `planning.md` — task-plan conventions
- `prose-style.md` — general prose conventions
- `quantitative-writing.md` — measurements, comparisons, and statistical findings
- `scripting.md` — script language selection
- `technical-writing.md` — technical-documentation conventions

The root instruction file stays minimal. Agents load the linked guidance only when its task trigger applies.

### Harness setup

Harness adapters are not maintained by this repository. Configure each harness to load `agents/AGENTS.md` directly, or create a local adapter in the location that harness expects. The adapter should point to the canonical file rather than duplicate its contents, for example:

```markdown
Before any task, read and follow the repository-root `agents/AGENTS.md`, including any task-specific guidance it links.
```

Check the harness documentation for its current adapter location and format.

## Live paths

- `~/.config/nvim` -> `~/dev/dotfiles/nvim`
- `~/.zshrc` -> `~/dev/dotfiles/zshrc/.zshrc`

## Prerequisites on a new machine

Install at least:

- `git`
- `zsh`
- `nvim`

For a better Neovim experience, also install:

- `rg`
- `fd`
- `tree-sitter`
- `node`
- `npm`

## Setup on a new machine

Clone the repo:

```sh
mkdir -p ~/dev
git clone https://github.com/builtbyly/dotfiles ~/dev/dotfiles
```

Back up any existing config you want to keep:

```sh
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.zshrc ~/.zshrc.backup
```

Create the symlinks:

```sh
mkdir -p ~/.config
ln -s ~/dev/dotfiles/nvim ~/.config/nvim
ln -s ~/dev/dotfiles/zshrc/.zshrc ~/.zshrc
```

Reload zsh:

```sh
source ~/.zshrc
```

Launch Neovim:

```sh
nvim
```

On first launch, LazyVim/plugins should install automatically.
