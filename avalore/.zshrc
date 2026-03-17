#
# ~/.zshrc
#

bindkey -v
setopt prompt_subst

export EDITOR=/opt/homebrew/bin/nvim
export LEDGER_FILE=~/personal/notes/finance/main.journal

# Prompt
autoload -U colors && colors
PROMPT='%F{green}%n@%m%f:%F{blue}%1~%f
%(?.%F{yellow}.%F{red})$%f '

# aliases
# alias ls='ls -l --color=auto'
# alias lsl='ls -al --color=auto'
# alias lat='tree -L 2 -a'
alias ls="eza -l --git"
alias lsl="eza -l --git -a"
alias lt="eza --tree --level=2 --long --git"
alias tm='tmux'
alias hl='hledger'

. "$HOME/.local/bin/env"

# enable fzf in zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
