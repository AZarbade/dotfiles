#!/bin/bash

set -e

# Function to check for root privileges
check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo "Please do not run this script as root."
        exit 1
    fi
}

# Function to install packages using pacman
install_packages() {
    echo "Updating system and installing packages..."
    sudo pacman -Syu --noconfirm \
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
        ttf-input-nerd \
        fd \
        ripgrep \
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
        wtype \
        tofi \
        pwvucontrol \
        timeshift \
        timeshift-autosnap \
        timeshift-systemd-timer \
        polkit-kde-agent \
        grub-btrfs \
        nautilus \
        xorg-xhost \
        networkmanager \
        stow
}

# Function to install AUR packages manually via git and makepkg
install_aur_package() {
    PACKAGE_NAME=$1
    echo "Installing AUR package: $PACKAGE_NAME..."
    git clone "https://aur.archlinux.org/$PACKAGE_NAME.git" /tmp/$PACKAGE_NAME
    cd /tmp/$PACKAGE_NAME
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/$PACKAGE_NAME
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

# Function to install Hyprland
install_hyprland() {
    echo "Installing Hyprland..."
    sudo pacman -S --noconfirm hyprland
}

# Function to link dotfiles
stow_dotfiles() {
    echo "Linking dotfiles..."
    stow avalore/
}

# Main script execution
check_root
install_packages
install_rust
install_atuin
install_hyprland
stow_dotfiles

# Final steps: Update full system and run wal command
echo "Updating the full system..."
sudo pacman -Syu --noconfirm

echo "Running wal with the specified theme..."
wal --theme "$HOME/.config/wal/colorschemes/dark/base16-og-gruvbox-hard.json"

echo "Installation and configuration complete. Please reboot your system and run 'Hyprland'."
