# shellcheck shell=zsh
typeset -g ZGENOM_HOME="${HOME}/.zgenom"
autoload -Uz compinit

if [[ ! -d "$ZGENOM_HOME" ]]; then
  if command -v git >/dev/null 2>&1; then
    printf 'Installing zgenom into %s...\n' "$ZGENOM_HOME" >&2
    git clone https://github.com/jandamm/zgenom.git "$ZGENOM_HOME" >/dev/null 2>&1 || {
      printf 'Could not install zgenom; skipping plugin load.\n' >&2
      return
    }
  else
    printf 'Zgenom not found at %s. Install git and clone https://github.com/jandamm/zgenom.git there.\n' "$ZGENOM_HOME" >&2
    return
  fi
fi

source "$ZGENOM_HOME/zgenom.zsh"

if ! zgenom saved; then
  zgenom autoupdate 7

  # Prompt/theme
  zgenom load romkatv/powerlevel10k powerlevel10k

  # Productivity and completion enhancements
  zgenom load zsh-users/zsh-completions
  zgenom load Aloxaf/fzf-tab
  zgenom load wfxr/forgit
  zgenom load rupa/z
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load jeffreytse/zsh-vi-mode
  zgenom load zdharma-continuum/fast-syntax-highlighting

  zgenom compinit
  zgenom save
fi

# Plugin-specific configuration
zstyle ':completion:*' use-cache yes
zstyle ':fzf-tab:*' fzf-command 'fzf --height 40% --border'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G -a $realpath'
zstyle ':forgit:log' pager 'less -R'
