# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/wrongcolor/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# starship source
eval "$(starship init zsh)"

# aliases
alias ls='exa'
alias ll='exa -a'
alias v='nvim .'
alias tm='tmux -u'
alias spd='speedtest-rs'
alias ya='yazi'
alias btop='btop --utf-force'
alias sd='cd $(find * -type d | fzf)'

# git aliases
alias ga='git add'
alias gcm='git commit -m'
alias gco='git checkout'
alias gst='git status'
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
    nvim .
    cd ~
}

