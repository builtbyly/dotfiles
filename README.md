# dotfiles

This repository tracks configuration and reusable agent instructions for:

- `agents/`
- `nvim/`
- `zshrc/`

## Agent instructions

`agents/AGENTS.md` contains the project-wide agent guardrails and links to task-specific guidance under `agents/docs/agent-guidelines/`:

- `ai-attribution.md` — AI disclosure and DCO signoff
- `changes-and-review.md` — code changes, review passes, and pull-request organization
- `git-workflow.md` — commits, branches, rebasing, and pushes
- `prose-style.md` — general prose conventions
- `scripting.md` — script language selection
- `technical-writing.md` — technical-documentation conventions

The root instruction file stays minimal. Agents load the linked guidance only when its task trigger applies.

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
