# dotfiles

Repo:

- `https://github.com/builtbyly/dotfiles`

This repo currently tracks only the config I care about keeping:

- `nvim/`
- `zshrc/`

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
