##### Portable zsh config: oh-my-zsh + powerlevel10k + tmux (VSCode-safe)
##### ───────────────────────────────
#####  Powerlevel10k Instant Prompt
#####  (must stay at the very top)
##### ───────────────────────────────
# Load cached instant prompt if available.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Exit early for non-interactive or non-tty shells
case $- in *i*) ;; *) return ;; esac
[[ -t 1 ]] || return

# --- Dotfiles root (override by exporting DOTFILES_DIR before launching zsh)
: ${DOTFILES_DIR:="$HOME/.dotfiles"}

# --- Paths to modules (oh-my-zsh / powerlevel10k live in ./modules)
export ZSH="$DOTFILES_DIR/modules/ohmyzsh"
export P10K_ROOT="$DOTFILES_DIR/modules/powerlevel10k"

# Locale (UTF-8 everywhere)
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# --- Powerlevel10k instant prompt: source user config if present
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# --- oh-my-zsh (minimal & fast)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git)    # keep lean for HPC; add more as needed
  source "$ZSH/oh-my-zsh.sh"
fi

# --- QoL options
setopt COMPLETE_IN_WORD
alias scp='noglob scp'

# --- VSCode-safe tmux auto-start
is_interactive() { [[ $- == *i* ]]; }
is_tty()         { [[ -t 1 ]]; }
if is_interactive && is_tty \
   && command -v tmux >/dev/null 2>&1 \
   && [[ -z "$TMUX" ]] \
   && [[ "$TERM" != screen* && "$TERM" != tmux* ]] \
   && [[ "$TERM_PROGRAM" != "vscode" ]] \
   && [[ -z "$VSCODE_GIT_IPC_HANDLE" ]]; then

  if [[ "$LC_TERMINAL" == "iTerm2" || "$TERM_PROGRAM" == "iTerm.app" ]]; then
    tmux -CC attach -t default 2>/dev/null || tmux -CC new -s default
  else
    tmux attach -t default 2>/dev/null || tmux new -s default
  fi
fi
alias t='tmux attach -t default 2>/dev/null || tmux new -s default'

# --- Editor defaults
export EDITOR="nvim"
export VISUAL="$EDITOR"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
# (keep the portable Neovim path as a fallback if you like)
[[ -d "$HOME/apps/nvim-linux64/bin" ]] && export PATH="$HOME/apps/nvim-linux64/bin:$PATH"
[[ -d "$HOME/apps/nvim-macos-arm64/bin" ]] && export PATH="$HOME/apps/nvim-macos-arm64/bin:$PATH"
[[ -d "$HOME/apps/nvim-macos-x86_64/bin" ]] && export PATH="$HOME/apps/nvim-macos-x86_64/bin:$PATH"

# --- Optional: your ~/bin
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"

# Prefer lvim when available, else fallback to nvim/vim
if command -v lvim >/dev/null 2>&1; then
  alias vi='lvim'
  alias vim='lvim'
elif command -v nvim >/dev/null 2>&1; then
  alias vi='nvim'
  alias vim='nvim'
else
  alias vi='vim'
fi

unset VIMRUNTIME

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - zsh)"

# Added by Antigravity
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
