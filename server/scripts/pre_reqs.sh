#!/bin/bash

# Function to check if the last command was successful
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error during $1. Exiting."
        exit 1
    fi
}

# Function to install packages using apt
install_packages() {
    local packages=("$@")
    
    sudo apt-get update
    sudo apt-get install -y "${packages[@]}"
    
    # Verify installation
    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "Error: $package is not installed or not in PATH after installation attempt."
            echo "Please install it manually and ensure it's in your PATH."
            exit 1
        fi
    done
}

# Function to install Fish shell
install_fish() {
    echo "Installing Fish shell..."
    echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
    curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    sudo apt-get update
    sudo apt-get install -y fish
    check_status "Fish shell installation"
}

# Function to install Nerd Font
install_nerd_font() {
    local font_name="JetBrainsMono"
    echo "[-] Downloading $font_name Nerd Font [-]"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
    echo "Download URL: $url"
    # Download the font
    if ! curl -OL "$url"; then
        echo "Error: Failed to download $font_name.zip"
        exit 1
    fi
    # Create fonts directory
    local fonts_dir="${HOME}/.local/share/fonts/$font_name"
    echo "Creating fonts folder: $fonts_dir"
    mkdir -p "$fonts_dir"
    # Unzip the font
    echo "Unzipping $font_name.zip"
    if ! unzip -o "$font_name.zip" -d "$fonts_dir/"; then
        echo "Error: Failed to unzip $font_name.zip"
        exit 1
    fi
    # Clean up
    echo "Cleaning up"
    rm "$font_name.zip"
    echo "$font_name Nerd Font has been successfully installed!"
}

# Function to update MOTD with hostname in ANSI Shadow font
update_motd() {
    echo "Updating MOTD..."
    # Get the hostname
    hostname=$(hostname)

    # Install figlet and figlet-fonts if not already installed
    if ! command -v figlet &> /dev/null; then
        echo "figlet is not installed. Installing now..."
        install_packages figlet figlet-fonts
    fi

    # Check if ANSI Shadow font is available
    if ! figlet -f "ANSI Shadow" "test" &> /dev/null; then
        echo "ANSI Shadow font is not available. Please ensure figlet-fonts is installed."
        exit 1
    fi

    # Generate ASCII art of hostname with ANSI Shadow font
    ascii_hostname=$(figlet -f "ANSI Shadow" "$hostname")

    # Edit /etc/motd directly
    sudo tee /etc/motd > /dev/null << EOF
$ascii_hostname
EOF

    echo "MOTD has been updated with the hostname in ASCII art using the ANSI Shadow font."
}

# Main script execution
echo "Starting setup..."

# Install basic utilities
echo "Installing basic utilities..."
install_packages htop git curl wget unzip tmux fzf stow
check_status "basic utilities installation"

# Install Fish shell
install_fish

# Install Nerd Font
install_nerd_font

# Update MOTD
update_motd

# Setting fish as default user shell
chsh -s /usr/bin/fish hol

echo "Setup completed successfully!"
