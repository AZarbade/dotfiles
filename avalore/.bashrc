#
# ~/.bashrc
#

# Start hyprland through UWSM
if uwsm check may-start; then
    exec uwsm start hyprland-uwsm.desktop
fi

# aliases
alias ls='ls -al'
alias sys='sudo systemctl '
alias tm='tmux'

# binds
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'
