#!/usr/bin/bash
cd $(tmux run "echo #{pane_start_path}") && \
git remote get-url origin | sed 's/git@\([^:]*\):\(.*\)\.git$/https:\/\/\1\/\2/' | xargs xdg-open
