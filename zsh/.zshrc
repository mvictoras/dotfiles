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
  plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
  source "$ZSH/oh-my-zsh.sh"
fi

# --- QoL options
setopt COMPLETE_IN_WORD
alias scp='noglob scp'

# --- Remote-only tmux auto-start (useful for SSH/HPC sessions)
is_interactive() { [[ $- == *i* ]]; }
is_tty()         { [[ -t 1 ]]; }
is_remote_shell() {
  [[ -n "$SSH_CONNECTION" || -n "$SSH_TTY" || -n "$SSH_CLIENT" || -n "$REMOTEHOST" ]]
}
if is_interactive && is_tty \
   && is_remote_shell \
   && command -v tmux >/dev/null 2>&1 \
   && [[ -z "$TMUX" ]] \
   && [[ "$TERM" != screen* && "$TERM" != tmux* ]] \
   && [[ "$TERM_PROGRAM" != "vscode" ]] \
   && [[ -z "$VSCODE_GIT_IPC_HANDLE" ]]; then

  tmux attach -t default 2>/dev/null || tmux new -s default
fi

# --- ALCF proxy settings
is_alcf_host() {
  [[ "$HOST" == *.alcf.anl.gov || "$HOST" == *.alcf.anl.gov.* || "$HOST" == *alcf.anl.gov* \
     || "$REMOTEHOST" == *.alcf.anl.gov || "$REMOTEHOST" == *.alcf.anl.gov.* || "$REMOTEHOST" == *alcf.anl.gov* ]]
}
if is_alcf_host; then
  export HTTP_PROXY="http://proxy.alcf.anl.gov:3128"
  export HTTPS_PROXY="http://proxy.alcf.anl.gov:3128"
  export http_proxy="http://proxy.alcf.anl.gov:3128"
  export https_proxy="http://proxy.alcf.anl.gov:3128"
  export ftp_proxy="http://proxy.alcf.anl.gov:3128"
  export no_proxy="admin,polaris-adminvm-01,localhost,*.cm.polaris.alcf.anl.gov,polaris-*,*.polaris.alcf.anl.gov,*.alcf.anl.gov"
fi
alias t='tmux attach -t default 2>/dev/null || tmux new -s default'
alias ff='fd --type f | fzf'
alias cdf='cd "$(fd --type d | fzf)"'
alias rgi='rg --ignore-case'

fif() {
  rg --ignore-case --line-number --no-heading "$@" | fzf
}

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

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Added by Antigravity
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
