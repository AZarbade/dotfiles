#!/bin/bash

# Ensure script is run with sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (use sudo ./install.sh)"
  exit
fi

# Update and upgrade the system
apt update && apt upgrade -y

# Install necessary tools
apt install -y curl wget build-essential

# Install terminal (Alacritty)
add-apt-repository ppa:aslatter/ppa -y
apt update
apt install -y alacritty

# Install Rust (required for bat and git-graph)
su - $SUDO_USER -c 'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y'
su - $SUDO_USER -c 'source $HOME/.cargo/env' 

# Install cargo applications
su - $SUDO_USER -c 'cargo install bat git-graph exa'

# Install fish (shell)
add-apt-repository ppa:fish-shell/release-3 -y
apt update
apt install -y fish

# Install neofetch
apt install -y neofetch

# Ensure dependencies are installed
apt install -y coreutils fzf fd-find

# Install atuin (shell history)
bash <(curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh)

# Install Neovim
add-apt-repository ppa:neovim-ppa/stable -y
apt update
apt install -y neovim

# Install tmux
apt install -y tmux

# Install GNU Stow
apt install -y stow

# Install JetBrainsMono Nerd Font
mkdir -p /usr/local/share/fonts/nerd-fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d /usr/local/share/fonts/nerd-fonts/JetBrainsMono
rm JetBrainsMono.zip
fc-cache -fv

# Install dotfiles using stow
su - $SUDO_USER -c 'stow */'

echo "Installation complete!"
echo "Dotfiles have also been installed. Please review any conflict messages if they occurred."
