#
# ~/.bashrc
#

# settings
set -o vi

# prompt
PS1='\u@\h:\W\n$ '

# aliases
alias ls='ls -l --color=auto'
alias lsl='ls -al --color=auto'
alias tm='tmux'

. "$HOME/.cargo/env"
