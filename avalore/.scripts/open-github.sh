#! /usr/bin/bash

cd $(tmux run "echo #{pane_start_path}")
url=$(get remote get-url origin)

open $url || echo "No remote found"
