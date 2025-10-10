#
# ~/.bashrc
#

# Start hyprland through UWSM
if uwsm check may-start; then
    exec uwsm start hyprland-uwsm.desktop
fi

# prompt
git_branch() {
  local branch
  branch=$(git branch 2>/dev/null | grep '^*' | cut -d' ' -f2-)
  [[ -n "$branch" ]] && echo " ($branch)"
}
PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\u@\h'; else echo '\[\033[01;32m\]\u@\h'; fi)$(if [[ -n "$SSH_CLIENT" ]]; then echo '\[\033[01;33m\][SSH]\[\033[00m\]'; fi)\[\033[01;34m\] \w\[\033[01;35m\]\$(git_branch)\[\033[00m\]\n\$([[ \$? != 0 ]] && echo \"\")\\$ "

# settings
set -o vi

# aliases
alias ls='ls -al --color=auto'
alias sys='sudo systemctl '
alias tm='tmux'

# binds
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'
