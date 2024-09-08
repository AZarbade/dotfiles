#!/bin/bash

# File to store current theme state
THEME_STATE_FILE="$HOME/.current_theme"

# Function to set light theme
set_light_theme() {
    wal --theme ~/.config/wal/colorschemes/light/base16-og-gruvbox-hard.json
    echo "light" > "$THEME_STATE_FILE"
    ~/.config/hypr/scripts/reload_waybar.sh
}

# Function to set dark theme
set_dark_theme() {
    wal --theme ~/.config/wal/colorschemes/dark/base16-og-gruvbox-hard.json
    echo "dark" > "$THEME_STATE_FILE"
    ~/.config/hypr/scripts/reload_waybar.sh
}

# Check current theme and toggle
if [ -f "$THEME_STATE_FILE" ]; then
    current_theme=$(cat "$THEME_STATE_FILE")
    if [ "$current_theme" = "light" ]; then
        set_dark_theme
    else
        set_light_theme
    fi
else
    # If no state file exists, default to light theme
    set_light_theme
fi
