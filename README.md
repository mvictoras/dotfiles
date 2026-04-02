# Dotfiles

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

## What's included

- **zsh** — oh-my-zsh + Powerlevel10k prompt
- **tmux** — vi mode, mouse support, sensible defaults
- **LunarVim** — Neovim distribution with LSP (clangd, basedpyright, lua_ls)

## Install

```bash
git clone --recursive https://github.com/mvictoras/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## Update submodules

```bash
git submodule update --init --recursive     # restore pinned versions
git submodule update --init --remote        # upgrade to latest
```
