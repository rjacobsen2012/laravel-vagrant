if [[ -n "$ITERM_SESSION_ID" ]]; then
  function change-profile() {
    echo -ne "\033]50;SetProfile=$1\a"
  }

  function reset-colors() {
    echo -ne "\033]6;1;bg;*;Default\a"
    change-profile Default
  }

  function sshterm() {
    if [[ "$1" =~ "^ssh " ]]; then
      if [[ "$@*" =~ "production" ]]; then
        change-profile ssh_production
      elif [[ "$@*" =~ "development" ]]; then
        change-profile ssh_homeserver
      fi
    elif [[ "$1" =~ "^vagrant " ]]; then
      if [[ "$*" =~ "ssh" ]]; then
        change-profile ssh_vagrant
      fi
    else
      reset-colors
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook precmd reset-colors
  add-zsh-hook preexec sshterm
fi
