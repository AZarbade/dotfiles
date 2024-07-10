#!/bin/bash

P=$(tmux show -wqv @notes_pane)
if [ -n "$P" ] && tmux lsp -F'#{pane_id}' | grep -q "^$P"; then
    tmux select-pane -t$P
    tmux break-pane -d -n _hidden_notes
    tmux set -wu @notes_pane
else
    P=$(tmux split-window -h -p 30 -PF'#{pane_id}' -c "#{pane_current_path} -l 60" 'exec fish')
    tmux set -w @notes_pane "$P"
fi
