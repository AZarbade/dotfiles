#!/bin/bash

set -e

# Function to check for root privileges
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
}

# Function to install packages using yay
install_packages() {
    echo "Updating system and installing packages..."
    yay -Syu --noconfirm \
        firefox \
        alacritty \
        fish \
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
        nvidia-dkms \
        nvidia-utils \
        egl-wayland \
        lib32-nvidia-utils \
        hyprpolkitagent \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk \
        cmake \
        meson \
        cpio \
        pwvucontrol \
        wl-clipboard
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

# Function to modify mkinitcpio configuration
modify_mkinitcpio() {
    echo "Modifying /etc/mkinitcpio.conf..."
    if grep -q '^MODULES=' /etc/mkinitcpio.conf; then
        sed -i 's/^MODULES=.*/MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)/' /etc/mkinitcpio.conf
    else
        echo 'MODULES=(... nvidia nvidia_modeset nvidia_uvm nvidia_drm ...)' >> /etc/mkinitcpio.conf
    fi
}

# Function to set up NVIDIA module options
setup_nvidia_conf() {
    echo "Setting up NVIDIA configuration..."
    echo "options nvidia_drm modeset=1 fbdev=1" > /etc/modprobe.d/nvidia.conf
}

# Function to rebuild initramfs
rebuild_initramfs() {
    echo "Rebuilding initramfs..."
    mkinitcpio -P
}

# Main script execution
check_root
install_packages
install_rust
install_atuin
modify_mkinitcpio
setup_nvidia_conf
rebuild_initramfs

echo "Installation and configuration complete. Please reboot your system."
