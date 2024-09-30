#!/bin/bash

# Function to check if the last command was successful
check_status() {
  if [ $? -ne 0 ]; then
    echo "Error during $1 installation. Exiting."
    exit 1
  fi
}

# Update and install basic utilities
echo "Installing basic utilities..."
sudo apt update
sudo apt install htop git curl wget unzip tmux fzf -y
check_status "basic utilities"

# Install Fish shell
echo "Installing Fish shell..."
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
sudo apt update
sudo apt install fish -y
check_status "Fish shell"

# Install Atuin
echo "Installing Atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
check_status "Atuin"

# Run font_install.sh if it exists
FONT_SCRIPT="font_install.sh"

if [ -f "$FONT_SCRIPT" ]; then
  echo "Running font installation script..."
  bash "$FONT_SCRIPT"
  check_status "font installation"
else
  echo "Font installation script not found!"
fi
