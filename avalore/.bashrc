#
# ~/.bashrc
#

# Start hyprland through UWSM
if uwsm check may-start; then
    exec uwsm start hyprland-uwsm.desktop
fi

# settings
set -o vi

# prompt
git_branch() {
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    status=$(git status --porcelain 2>/dev/null)
    if [ -n "$status" ]; then
      echo "± ${branch}"
    else
      echo "✓ ${branch}"
    fi
  fi
}

is_ssh() {
  if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    echo "\[\e[38;5;208m\][SSH]\[\e[0m\] "
  fi
}

PS1='$(is_ssh)\[\e[97m\]\u@\h\[\e[0m\] \[\e[38;5;39m\]\w\[\e[0m\] \[\e[38;5;141m\]$(git_branch)\[\e[0m\] \[\e[38;5;208m\]|\[\e[0m\]\n\$ '

# aliases
alias ls='ls -al --color=auto'
alias sys='sudo systemctl '
alias tm='tmux'

# binds
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'

. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
