#!/bin/bash

SCRATCHPAD_NAME="scratchpad"

if hyprctl clients | grep "$SCRATCHPAD_NAME"; then
    hyprctl dispatch closewindow "title:$SCRATCHPAD_NAME"
else
    TEMP_FILE=$(mktemp /tmp/scratchpad_XXXXXX.txt)
    alacritty --title "$SCRATCHPAD_NAME" -e nvim "$TEMP_FILE" &
fi
