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

PS1='\[\e[38;5;240m\][\t]\[\e[0m\] \[\e[97m\]\u@\h\[\e[0m\] \[\e[38;5;208m\]|\[\e[0m\]\[\e[38;5;141m\]$(git_branch)\[\e[0m\] '

# settings
set -o vi

# aliases
alias ls='ls -al --color=auto'
alias sys='sudo systemctl '
alias tm='tmux'

# binds
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'

# opencode
export PATH=/home/noir/.opencode/bin:$PATH
