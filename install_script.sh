#!/bin/bash

set -e

# Function to check for root privileges
check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo "Please do not run this script as root."
        exit 1
    fi
}

# Function to install yay if not already installed
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Installing yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
    else
        echo "yay is already installed."
    fi
}

# Function to install packages using yay
install_packages() {
    echo "Updating system and installing packages..."
    yay -Syu --noconfirm \
		nvidia \
		nvidia-utils \
		egl-wayland \
        alacritty \
        fish \
		cmake \
		meson \
		cpio \
        htop \
        nvtop \
        eza \
        git-delta \
        python-pywal16 \
        dunst \
        neovim \
        tmux \
        waybar \
        ttf-jetbrains-mono-nerd \
        ttf-font-awesome \
        fd \
        fzf \
        hyprpaper \
        hypridle \
        hyprlock \
        hyprpm \
        lib32-nvidia-utils \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk \
		firefox \
        wl-clipboard \
        stow
}

# Function to install Rust
install_rust() {
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

# Function to install Atuin
install_atuin() {
    echo "Installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
}

# Main script execution
check_root
install_yay
install_packages
install_rust
install_atuin

# Final steps: Update full system and run wal command
echo "Updating the full system..."
yay -Syu --noconfirm

echo "Running wal with the specified theme..."
wal --theme $HOME/.config/wal/colorschemes/dark/base16-og-gruvbox-hard.json

echo "Installation and configuration complete. Please reboot your system."

