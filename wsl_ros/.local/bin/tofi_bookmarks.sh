#!/bin/bash

# Path to your URL file
url_file="$HOME/.bookmarks"
if [ ! -f "$url_file" ]; then
    echo "URL file not found: $url_file"
    exit 1
fi

# Read URLs from the file and display in tofi
mapfile -t urls < "$url_file"
selected=$(printf '%s\n' "${urls[@]}" | tofi --prompt="Select a URL: ")

if [ -n "$selected" ]; then
    url=$(echo "$selected" | awk -F' #' '{print $1}')
    echo -n "$url" | wl-copy
	wtype -M ctrl v -m ctrl
fi
