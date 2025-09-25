# interactive installer; courtesy of claude.ai
# idea from DHH omarchy

#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
NC='\033[0m'

install() {
    # Check for required dependencies
    command -v notify-send >/dev/null 2>&1 || { echo -e "${RED}notify-send not found. Install libnotify.${NC}"; return 1; }
    command -v yay >/dev/null 2>&1 || { echo -e "${RED}yay not found. Install yay first.${NC}"; return 1; }
    command -v fzf >/dev/null 2>&1 || { echo -e "${RED}fzf not found. Install fzf.${NC}"; return 1; }

    echo -e "${CYAN}Loading packages...${NC}"
    
    local selection
    selection=$(yay -Slq | fzf -m \
        --height=80% --layout=reverse --border=rounded \
        --prompt="📦 Select: " --pointer="▶" --marker="✓" \
        --preview 'yay -Si {1} 2>/dev/null || echo "No info"' \
        --preview-window=right:50% \
        --header='Tab: select • Enter: confirm • Esc: cancel' \
        --bind 'ctrl-a:select-all,ctrl-d:deselect-all')
    
    [[ -z $selection ]] && { echo -e "${YELLOW}Cancelled${NC}"; return; }
    
    local count
    count=$(echo "$selection" | wc -l)
    echo -e "\n${GREEN}Selected $count packages:${NC}"
    echo "$selection" | nl -w2 -s'. '
    
    echo -ne "\n${YELLOW}Install? (y/N): ${NC}"
    read -t 30 -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo -e "${CYAN}Installing...${NC}"
        notify-send "Package Manager" "Installing $count packages..." --icon=software-install
        
        local packages
        packages=$(echo "$selection" | tr '\n' ' ')
        
        if yay -S --noconfirm --needed $packages; then
            echo -e "${GREEN}✅ $count packages installed successfully${NC}"
            notify-send "Package Manager" "✅ Successfully installed $count packages" --icon=software-install
            
            echo -e "${BLUE}Cleaning package cache...${NC}"
            _clean_cache_auto
        else
            echo -e "${RED}❌ Installation failed${NC}"
            notify-send "Package Manager" "❌ Installation failed" --icon=error --urgency=critical
            return 1
        fi
    else
        echo -e "${YELLOW}Cancelled${NC}"
    fi
}

_clean_cache_auto() {
    _show_spinner &
    local spinner_pid=$!
    
    yay -Sc --noconfirm >/dev/null 2>&1
    
    kill $spinner_pid 2>/dev/null
    echo -ne "\r"
    
    echo -e "${GREEN}✅ Cache cleaned${NC}"
}

_show_spinner() {
    local spinstr='|/-\'
    local temp
    while true; do
        temp=${spinstr#?}
        printf "\r${CYAN}[%c] Cleaning cache...${NC}" "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep 0.1
    done
}

# Run
install
