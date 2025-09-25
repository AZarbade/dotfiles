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
# PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\u@\h'; else echo '\[\033[01;32m\]\u@\h'; fi)\[\033[01;34m\] \w\[\033[01;35m\]\$(git_branch)\[\033[00m\]\n\$([[ \$? != 0 ]] && echo \"\")\\$ "
PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\u@\h'; else echo '\[\033[01;32m\]\u@\h'; fi)$(if [[ -n "$SSH_CLIENT" ]]; then echo '\[\033[01;33m\][SSH]\[\033[00m\]'; fi)\[\033[01;34m\] \w\[\033[01;35m\]\$(git_branch)\[\033[00m\]\n\$([[ \$? != 0 ]] && echo \"\")\\$ "

# exports
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

# settings
set -o vi

# aliases
alias ls='ls -al'
alias sys='sudo systemctl '
alias tm='tmux'

# binds
bind -x $'"\C-l":clear;'
bind -x '"\C-p": "clear; $HOME/dotfiles/avalore/.scripts/tmux-session.sh"'

# interactive install; courtesy of claude.ai
install() {
    local RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m' 
    local CYAN='\033[0;36m' WHITE='\033[1;37m' NC='\033[0m'

    echo -e "${CYAN}Loading packages...${NC}"
    
    local selection=$(yay -Slq | fzf -m \
        --height=80% --layout=reverse --border=rounded \
        --prompt="📦 Select: " --pointer="▶" --marker="✓" \
        --preview 'yay -Si {1} 2>/dev/null || echo "No info"' \
        --preview-window=right:50% \
        --header='Tab: select • Enter: confirm • Esc: cancel' \
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all')
    
    [[ -z $selection ]] && { echo -e "${YELLOW}Cancelled${NC}"; return; }
    
    local count=$(echo "$selection" | wc -l)
    echo -e "\n${GREEN}Selected $count packages:${NC}"
    echo "$selection" | nl -w2 -s'. '
    
    echo -e "\n${YELLOW}Install? (y/N):${NC} "
    read -t 30 -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Installing...${NC}"
        local packages=$(echo "$selection" | tr '\n' ' ')
        
        if yay -S --noconfirm --needed $packages; then
            echo -e "${GREEN}✅ $count packages installed${NC}"
        else
            echo -e "${RED}❌ Installation failed${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
}
