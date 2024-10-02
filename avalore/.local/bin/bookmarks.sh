#!/bin/bash

YDOTOOL_SOCKET="/tmp/.ydotool_socket" ydotool type $(grep -v '^#' $HOME/dotfiles/bookmarks | tofi | cut -d' ' -f1)
