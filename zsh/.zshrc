# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Basic zsh setup: trimmed down to environment, history, and a lightweight prompt.

setopt EXTENDED_GLOB

# Homebrew path helpers (keep whatever is already installed available).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY SHARE_HISTORY

setopt AUTO_CD PROMPT_SUBST INTERACTIVE_COMMENTS NO_NOMATCH

autoload -Uz colors compinit
colors
compinit -u

CONFIG_ZSH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
if [[ -f "$CONFIG_ZSH_DIR/zgenom.zsh" ]]; then
  source "$CONFIG_ZSH_DIR/zgenom.zsh"
fi

typeset -ga precmd_functions
typeset -g __ZSH_SETUP_GIT_PROMPT=""

# Collect git status details (branch, staged/unstaged/untracked counts, ahead/behind, stash).
__zsh_setup_git_prompt() {
  __ZSH_SETUP_GIT_PROMPT=""
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local git_status line
  local ahead=0 behind=0 staged=0 unstaged=0 untracked=0
  local branch
  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || true)"
  if [[ -z $branch ]]; then
    branch="$(git rev-parse --short HEAD 2>/dev/null || true)"
  fi
  [[ -z $branch ]] && branch='detached'

  git_status="$(git status --porcelain --branch 2>/dev/null)" || return

  while IFS= read -r line; do
    if [[ ${line:0:3} == '## ' ]]; then
      local meta="${line#\#\# }"
      if [[ $meta == *'['* ]]; then
        local bracket="${meta#*[}"
        bracket="${bracket%]}"
        local ahead_part behind_part
        if [[ $bracket == *ahead* ]]; then
          ahead_part="${bracket#*ahead }"
          ahead_part="${ahead_part%%,*}"
          ahead_part="${ahead_part%% *}"
          [[ -n $ahead_part ]] && ahead=$ahead_part
        fi
        if [[ $bracket == *behind* ]]; then
          behind_part="${bracket#*behind }"
          behind_part="${behind_part%%,*}"
          behind_part="${behind_part%% *}"
          [[ -n $behind_part ]] && behind=$behind_part
        fi
      fi
    elif [[ ${line:0:3} == '?? ' ]]; then
      ((untracked++))
    elif [[ ${line:0:3} == '!! ' ]]; then
      continue
    else
      local staged_code="${line:0:1}"
      local unstaged_code="${line:1:1}"
      case "$staged_code" in
        [MADRCU]) ((staged++)) ;;
      esac
      case "$unstaged_code" in
        [MADRCU]) ((unstaged++)) ;;
      esac
    fi
  done <<< "$git_status"

  local stash_count=0
  if git rev-parse --verify refs/stash >/dev/null 2>&1; then
    stash_count="$(git rev-list --count refs/stash 2>/dev/null)"
  fi

  local parts=()
  parts+=("%F{yellow} ${branch}%f")
  ((staged)) && parts+=("%F{green}+${staged}%f")
  ((unstaged)) && parts+=("%F{red}!${unstaged}%f")
  ((untracked)) && parts+=("%F{magenta}?${untracked}%f")
  ((ahead)) && parts+=("%F{blue}↑${ahead}%f")
  ((behind)) && parts+=("%F{blue}↓${behind}%f")
  ((stash_count)) && parts+=("%F{cyan}⚑${stash_count}%f")

  __ZSH_SETUP_GIT_PROMPT="${(j: :)parts}"
}
precmd_functions+=(__zsh_setup_git_prompt)

# Simple prompt that surfaces git branch/status info (needs Nerd Font for icons).
PROMPT='%F{cyan}%n%f %F{blue}%~%f${__ZSH_SETUP_GIT_PROMPT:+ ${__ZSH_SETUP_GIT_PROMPT}} %F{green}%f '

# Keybindings: Ctrl+Delete removes the next word chunk (treat punctuation as separators).
bindkey '^[[3;5~' kill-whole-word

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

alias refresh-shell='source ~/.zshrc'

[[ -d /Applications/Docker.app/Contents/Resources/bin ]] && path+=("/Applications/Docker.app/Contents/Resources/bin")

# Machine-specific overrides (aliases, secrets, tokens) live in ~/.zsh_local (not tracked).
[[ -f "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
