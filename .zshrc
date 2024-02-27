# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/wrongcolor/.zshrc'

plugins=(
  starship
  zsh-autosuggestions
)

autoload -Uz compinit
compinit
# End of lines added by compinstall

# starship source
eval "$(starship init zsh)"

# asdf config
. "$HOME/.asdf/asdf.sh"
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# aliases
alias ls='exa -l'
alias lsl='exa -la'
alias ll='exa -a'
alias tree='exa --tree'
alias v='nvim .'
alias tm='tmux -u'
alias spd='speedtest-rs'
alias ya='yazi'
alias btop='btop --utf-force'
alias sd='cd $(find * -type d | fzf)'
alias notes='cd ~/personal/avalore && nvim'

# bindkeys
bindkey -s '^p' 'cd $(find * -type d | fzf)\n'
bindkey -s '^e' 'nvim $(fzf)\n'
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# git aliases
alias gui='gitui'
alias gg='git-graph'

# Function to stop containers and unmount mediaServer
downmedia() {
    echo "Changing directory to ~/personal/mediaServer..."
    cd ~/personal/mediaServer || return  # Use || return to exit function if cd fails
    echo "Stopping Server"
    docker-compose down
    echo "Unmounting mediaServer..."
    sudo umount /mnt/media/
    echo "Changing directory back to ~..."
    cd ~
}

# Function to start containers in the background and mount mediaServer
upmedia() {
    echo "Mounting mediaServer..."
    sudo mount -a
    echo "Changing directory to ~/personal/mediaServer..."
    cd ~/personal/mediaServer || return
    echo "Starting"
    docker-compose up -d
    echo "Changing directory back to ~..."
    cd ~
}

# Function to edit config files
ce() {
    echo "Editing config files"
    cd ~/dotfiles || return
    nvim 
    cd ~
}

# startup commands
# echo "( |_| )"
# echo " _______           _______  _        _______  _______  _______  " 
# echo "(  ___  )|\     /|(  ___  )( \      (  ___  )(  ____ )(  ____ \ "
# echo "| (   ) || )   ( || (   ) || (      | (   ) || (    )|| (    \/ "
# echo "| (___) || |   | || (___) || |      | |   | || (____)|| (__     "
# echo "|  ___  |( (   ) )|  ___  || |      | |   | ||     __)|  __)    "
# echo "| (   ) | \ \_/ / | (   ) || |      | |   | || (\ (   | (       "
# echo "| )   ( |  \   /  | )   ( || (____/\| (___) || ) \ \__| (____/\ "
# echo "|/     \|   \_/   |/     \|(_______/(_______)|/   \__/(_______/ "

echo " "
echo "   █████╗ ██╗   ██╗ █████╗ ██╗      ██████╗ ██████╗ ███████╗ "
echo "  ██╔══██╗██║   ██║██╔══██╗██║     ██╔═══██╗██╔══██╗██╔════╝ "
echo "  ███████║██║   ██║███████║██║     ██║   ██║██████╔╝█████╗   "
echo "  ██╔══██║╚██╗ ██╔╝██╔══██║██║     ██║   ██║██╔══██╗██╔══╝   "
echo "  ██║  ██║ ╚████╔╝ ██║  ██║███████╗╚██████╔╝██║  ██║███████╗ "
echo "  ╚═╝  ╚═╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ "

