#!/bin/bash

# Function to install required tools
install_tools() {
    local tools=("curl" "unzip")
    
    echo "Installing required tools: ${tools[*]}"
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y "${tools[@]}"
    elif command -v yum &> /dev/null; then
        sudo yum install -y "${tools[@]}"
    else
        echo "Error: Unsupported package manager. Please install the following tools manually: ${tools[*]}"
        exit 1
    fi

    # Verify installation
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "Error: $tool is not installed or not in PATH after installation attempt."
            echo "Please install it manually and ensure it's in your PATH."
            exit 1
        fi
    done
    echo "All required tools have been successfully installed."
}

# Install required tools
install_tools

# Set font name
font_name="JetBrainsMono"

echo "[-] Downloading $font_name Nerd Font [-]"
url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font_name.zip"
echo "Download URL: $url"

# Download the font
if ! curl -OL "$url"; then
    echo "Error: Failed to download $font_name.zip"
    exit 1
fi

# Create fonts directory
fonts_dir="${HOME}/.local/share/fonts/$font_name"
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

echo "JetBrainsMono Nerd Font has been successfully installed!"
