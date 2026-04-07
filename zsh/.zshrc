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

is_polaris_compute_node() {
  [[ "$HOST" == *.hsn.cm.polaris.alcf.anl.gov || "$REMOTEHOST" == *.hsn.cm.polaris.alcf.anl.gov ]]
}

# Polaris compute nodes may not have tmux-256color terminfo installed.
if is_polaris_compute_node && [[ "$TERM" == "tmux-256color" ]]; then
  export TERM="xterm-256color"
fi

# Locale (UTF-8 everywhere)
export LANG=${LANG:-en_US.UTF-8}
export LC_ALL=${LC_ALL:-en_US.UTF-8}

# --- Powerlevel10k instant prompt: source user config if present
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Keep prompt simpler on Polaris compute nodes where terminal capabilities are often reduced.
if is_polaris_compute_node; then
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO,REMOTE,REMOTE_SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=30
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
  print -n -- $'\e[?1l\e>'
fi

# --- oh-my-zsh (minimal & fast)
OMZ_EXTRA_PLUGINS=()
[[ -r "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]] && OMZ_EXTRA_PLUGINS+=(zsh-autosuggestions)
[[ -r "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]] && OMZ_EXTRA_PLUGINS+=(zsh-syntax-highlighting)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git ${OMZ_EXTRA_PLUGINS[@]})
  source "$ZSH/oh-my-zsh.sh"
fi

[[ -r "$DOTFILES_DIR/modules/zsh-autosuggestions/zsh-autosuggestions.zsh" && ! " ${OMZ_EXTRA_PLUGINS[*]} " =~ " zsh-autosuggestions " ]] && source "$DOTFILES_DIR/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -r "$DOTFILES_DIR/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" && ! " ${OMZ_EXTRA_PLUGINS[*]} " =~ " zsh-syntax-highlighting " ]] && source "$DOTFILES_DIR/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- QoL options
setopt COMPLETE_IN_WORD
alias scp='noglob scp'

bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[OA' up-line-or-history
bindkey '^[OB' down-line-or-history

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
  [[ "$HOST" == sophia* || "$HOST" == *.hsn.* || "$HOST" == *alcf.anl.gov* \
     || "$REMOTEHOST" == sophia* || "$REMOTEHOST" == *.hsn.* || "$REMOTEHOST" == *alcf.anl.gov* ]]
}
if is_alcf_host; then
  export HTTP_PROXY="http://proxy.alcf.anl.gov:3128"
  export HTTPS_PROXY="http://proxy.alcf.anl.gov:3128"
  export http_proxy="http://proxy.alcf.anl.gov:3128"
  export https_proxy="http://proxy.alcf.anl.gov:3128"
  export ftp_proxy="http://proxy.alcf.anl.gov:3128"
  export no_proxy="admin,polaris-adminvm-01,localhost,*.cm.polaris.alcf.anl.gov,polaris-*,*.polaris.alcf.anl.gov,*.alcf.anl.gov"
  export GRAND="/lus/grand/projects/visualization/mvictoras/"
  alias grand='cd $GRAND'
  q() {
    if [[ $# -lt 2 || $# -gt 3 ]]; then
      print "usage: q project time_in_hours [queue]"
      return 1
    fi

    local project="$1"
    local hours="$2"
    local queue="${3:-visualization}"
    local walltime

    if [[ ! "$hours" =~ '^[0-9]+$' ]]; then
      print "q: time_in_hours must be an integer"
      return 1
    fi

    printf -v walltime '%02d:00:00' "$hours"
    qsub -I -l select=1 -l filesystems=home:eagle -l walltime="$walltime" -q "$queue" -A "$project" -I
  }
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

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init - zsh)"

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if is_polaris_compute_node && command -v opencode >/dev/null 2>&1; then
  opencode-safe() {
    print -n -- $'\e[?1l\e>'
    TERM=xterm-256color command opencode "$@"
  }
  alias opencode='opencode-safe'
fi

# Added by Antigravity
[[ -d "$HOME/.antigravity/antigravity/bin" ]] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
