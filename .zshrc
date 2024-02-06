# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="typewritten/typewritten" # set by `omz`

# plugins
plugins=(
  git
  fzf-zsh-plugin
)

source $ZSH/oh-my-zsh.sh

# binds for ctrl - < & >
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# general aliases
alias ll='tree -L 1'
alias ll2='tree -L 2'
alias tm='tmux -u'
alias spd='speedtest-rs'
alias ya='yazi'

# nvim aliases
alias v='nvim'
alias vz='nvim ~/dotfiles/.zshrc'
alias btop='btop --utf-force'

# git aliases
alias gui='gitui'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias ga='git add'
alias gg='git-graph'

# Function to stop and remove containers
downmedia() {
    echo "Changing directory to ~/personal/mediaServer..."
    cd ~/personal/mediaServer || return
    echo "Stopping Server"
    docker-compose down
    echo "Unmounting mediaServer..."
    sudo umount /mnt/share || return
    echo "Changing directory back to ~..."
    cd ~
}

# Function to start containers in the background
upmedia() {
    echo "Mounting mediaServer..."
    sudo mount -a || return
    echo "Changing directory to ~/personal/mediaServer..."
    cd ~/personal/mediaServer || return
    echo "Starting"
    docker-compose up -d
    echo "Changing directory back to ~..."
    cd ~
}

# Function to get .config editing setup
ce() {
  echo "Editing config files"
  cd ~/dotfiles/.config/ || return
  nvim .
  cd ~
}

# rust source
export PATH="$HOME/.cargo/bin:$PATH"

# zoxide init
eval "$(zoxide init zsh)"

#
