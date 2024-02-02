# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="typewritten/typewritten" # set by `omz`

# plugins
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# binds for ctrl - < & >
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# alias
alias ll='tree -L 1 -a'
alias ll2='tree -L 2 -a'
alias v='nvim'
alias vz='nvim ~/dotfiles/.zshrc'
alias btop='btop --utf-force'

# Function to stop and remove containers
downmedia() {
    echo "Changing directory to ~/personal/mediaServer..."
    cd ~/personal/mediaServer || return
    echo "Stopping Server"
    docker-compose down
    echo "Changing directory back to ~..."
    cd ~
}

# Function to start containers in the background
upmedia() {
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
