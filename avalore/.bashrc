#
# ~/.bashrc
#

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

PS1="\[\e[97m\]\u@\h\[\e[0m\] \[\e[38;5;39m\]\w\[\e[0m\] \[\e[38;5;141m\]\$(git_branch)\[\e[0m\] \[\e[38;5;208m\]|\[\e[0m\]\n\$ "

# aliases
alias ls='ls -l --color=auto'
alias lsl='ls -al --color=auto'
alias sys='sudo systemctl '
alias tm='tmux'
alias ncs='nrfutil toolchain-manager launch --ncs-version v3.2.1 --shell'

# binds
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'
