#
# ~/.zshrc
#

bindkey -v
setopt prompt_subst

export EDITOR=/opt/homebrew/bin/nvim

# prompt
PROMPT='%n@%m:%1~
$ '

# aliases
# alias ls='ls -l --color=auto'
# alias lsl='ls -al --color=auto'
# alias lat='tree -L 2 -a'
alias ls="eza -l --icons --git"
alias lsl="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias tm='tmux'

. "$HOME/.local/bin/env"

# enable fzf in zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
