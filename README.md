# Dotfiles

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

This setup is intentionally practical and lightweight:
- **zsh** with **oh-my-zsh**, **Powerlevel10k**, autosuggestions, and syntax highlighting
- **tmux** with mouse support, vi-style copy mode, and TPM plugins
- **LunarVim** with LSP for C/C++, Python, and Lua
- **Homebrew bootstrap** for common CLI tools on macOS/Linux Homebrew installs

## Install

```bash
git clone --recursive https://github.com/mvictoras/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

What `./install` does:
- links `~/.zshrc`, `~/.p10k.zsh`, `~/.tmux.conf`, and `~/.config/lvim`
- installs Brewfile packages when `brew` exists
- installs portable Neovim if `nvim` is missing
- installs LunarVim if `lvim` is missing

## Included tools

### Shell
- `oh-my-zsh`
- `powerlevel10k`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `fzf`
- `fd`
- `ripgrep`
- `bat`
- `eza`

### Tmux
- `tmux-plugins/tpm`
- `tmux-plugins/tmux-sensible`
- `tmux-plugins/tmux-resurrect`

### Editor
- `LunarVim`
- LSP servers: `clangd`, `basedpyright`, `lua_ls`

## Brewfile packages

If Homebrew is installed, `./install` runs:

```bash
brew bundle --file="$HOME/.dotfiles/Brewfile"
```

Current Brewfile packages:
- `fd`
- `fzf`
- `ripgrep`
- `tmux`
- `zsh`
- `bat`
- `eza`

## Cheatsheet

## Shell basics

### Useful aliases
```bash
t      # attach to tmux session "default" or create it
vi     # opens lvim if installed, else nvim, else vim
vim    # same behavior as vi
ff     # fuzzy-find a file with fd + fzf
cdf    # fuzzy-find a directory and cd into it
rgi    # case-insensitive ripgrep
```

### Useful shell function
```bash
fif something
```
Searches with `ripgrep` and pipes results into `fzf` for interactive filtering.

### FZF shell integration
When `fzf` is installed, `fzf --zsh` is loaded automatically.
Common defaults you’ll likely use:
- **Ctrl-T**: fuzzy-pick files/directories into the command line
- **Ctrl-R**: fuzzy search command history
- **Alt-C**: fuzzy-find a directory and cd into it

## Tmux cheatsheet

### Auto-start behavior
A new interactive terminal automatically attaches to a tmux session named `default`.
If tmux is not already running, it creates that session.

This auto-start is skipped for:
- VS Code integrated terminals
- shells already inside tmux

### Quick attach
```bash
t
```
Attach to `default` or create it.

### Key bindings
Assumes the normal tmux prefix (`Ctrl-b`) unless you changed it locally.

- `Prefix |` → split vertically
- `Prefix -` → split horizontally
- Mouse is enabled
- Copy mode uses **vi keys**
- In copy mode, press `y` to copy to the system clipboard

### TPM plugins
Inside tmux:
- `Prefix + I` → install TPM plugins
- `Prefix + Ctrl-s` → save tmux session (`tmux-resurrect`)
- `Prefix + Ctrl-r` → restore tmux session (`tmux-resurrect`)

## LunarVim cheatsheet

### What is configured
- format on save is enabled
- LSP is installed for:
  - `clangd`
  - `basedpyright`
  - `lua_ls`

### Remote / SSH behavior
When working over SSH, LunarVim automatically disables some UI features for speed:
- no startup dashboard
- no bufferline
- reduced terminal color usage

This is intentional for remote/HPC environments.

### ALCF / HPC shell behavior
On ALCF hosts:
- tmux auto-starts so your session survives disconnects
- ALCF proxy variables are exported automatically

On your local Mac:
- tmux does not auto-start
- ALCF proxy variables are not set

### Editor command behavior
```bash
vi file.txt
vim file.txt
```
These prefer `lvim`, then `nvim`, then plain `vim`.

## Powerlevel10k prompt

Your prompt is configured via:
```bash
~/.p10k.zsh
```

To reconfigure it interactively:
```bash
p10k configure
```

The prompt may show:
- git status
- command duration
- background jobs
- python/virtualenv info
- other environment context when detected

## Common tools examples

### ripgrep
```bash
rg TODO
rgi python
```

### fd
```bash
fd config
fd --type d src
```

### fzf
```bash
fd --type f | fzf
rg main | fzf
```

### bat
```bash
bat README.md
```

### eza
```bash
eza
eza -la
```

## Updating submodules

```bash
git submodule update --init --recursive
```
Restore pinned versions.

```bash
git submodule update --init --remote
```
Upgrade submodules to newer upstream versions.

## Troubleshooting

### Tmux plugins not working
Open tmux and run:
```bash
Prefix + I
```
That installs TPM plugins.

### `ff`, `cdf`, `fif` do nothing
Make sure these are installed:
```bash
brew install fd fzf ripgrep
```
Then open a new shell.

### `vi` opens the wrong editor
Check what is available:
```bash
command -v lvim
command -v nvim
command -v vim
```

### Prompt looks wrong
Make sure you have the Powerlevel10k theme and Nerd Font support in your terminal.
You can also rerun:
```bash
p10k configure
```
