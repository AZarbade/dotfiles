#!/bin/bash

# Path to your URL file
url_file="$HOME/dotfiles/bookmarks"

# Check if the file exists
if [ ! -f "$url_file" ]; then
    echo "URL file not found: $url_file"
    exit 1
fi

# Read URLs from the file
mapfile -t urls < "$url_file"

# Use tofi to display the URLs and capture the selection
selected=$(printf '%s\n' "${urls[@]}" | tofi --prompt="Select a URL: ")

# Check if a URL was selected
if [ -n "$selected" ]; then
    # Extract the URL part (before the #)
    url=$(echo "$selected" | awk -F' #' '{print $1}')
    
    # Copy the URL to clipboard using wl-copy
    echo -n "$url" | wl-copy
fi
