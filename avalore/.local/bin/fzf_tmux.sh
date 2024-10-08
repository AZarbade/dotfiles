#!/bin/bash
# File: gum_tmux.sh

# Define search lists
dirs=("$HOME/personal" "$HOME/dotfiles")

dir_list=$(fd --hidden --type d . "${dirs[@]}" 2>/dev/null | sort | uniq | sed 's/^/[DIR] /')
tmux_list=$(tmux list-sessions -F "#S" 2>/dev/null | sed 's/^/[TMUX] /')
combined_list=$(printf "%s\n%s" "$dir_list" "$tmux_list")

# Use fzf to select from the combined list
selected=$(echo "$combined_list" | fzf \
    --preview 'if [[ "{}" == \[tmux\]* ]]; then tmux capture-pane -pt "${$(cut -d" " -f2 <<< "{}")}" | sed /^$/d; else exa --tree {} | head -200; fi' \
    --preview-window right:50%:wrap \
    --prompt "Select directory or session: " \
    --header "↑↓:Navigate │ Enter:Select │ Ctrl-C:Cancel " \
    --border rounded \
    --height 40% \
    --color 'bg:#1d2021,fg:#fbf1c7,hl:#fabd2f'\
    --color 'fg+:#fbf1c7,bg+:#3c3836,hl+:#fabd2f'\
    --color 'info:#83a598,prompt:#bdae93,pointer:#fb4934'\
    --color 'marker:#fb4934,spinner:#fabd2f,header:#665c54'\
    --color 'border:#504945,preview-bg:#1d2021')

# Exit if nothing was selected
[ -z "$selected" ] && exit 0

# Check if the selection is a tmux session
if [[ $selected == \[tmux\]* ]]; then
    selected_name=$(echo "$selected" | cut -d' ' -f2)
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$selected_name"
    else
        tmux attach-session -t "$selected_name"
    fi
else
    # Create a valid session name
    selected_name=$(basename "$selected" | tr . _)
    # Check if we're in a tmux session
    if [ -n "$TMUX" ]; then
        # Inside tmux
        if tmux has-session -t "$selected_name" 2>/dev/null; then
            tmux switch-client -t "$selected_name"
        else
            tmux new-session -d -s "$selected_name" -c "$selected"
            tmux switch-client -t "$selected_name"
        fi
    else
        # Outside tmux
        if tmux has-session -t "$selected_name" 2>/dev/null; then
            tmux attach-session -t "$selected_name"
        else
            tmux new-session -s "$selected_name" -c "$selected"
        fi
    fi
fi




# # Use gum filter to select from the combined list
# selected=$(echo "$combined_list" | gum filter --placeholder "Select directory or session" --height 20)
#
# # Exit if nothing was selected
# [ -z "$selected" ] && exit 0
#
# # Check if the selection is a tmux session
# if [[ $selected == \[tmux\]* ]]; then
#     selected_name=$(echo "$selected" | cut -d' ' -f2)
#     if [ -n "$TMUX" ]; then
#         tmux switch-client -t "$selected_name"
#     else
#         tmux attach-session -t "$selected_name"
#     fi
# else
#     # Create a valid session name
#     selected_name=$(basename "$selected" | tr . _)
#     # Check if we're in a tmux session
#     if [ -n "$TMUX" ]; then
#         # Inside tmux
#         if tmux has-session -t "$selected_name" 2>/dev/null; then
#             tmux switch-client -t "$selected_name"
#         else
#             tmux new-session -d -s "$selected_name" -c "$selected"
#             tmux switch-client -t "$selected_name"
#         fi
#     else
#         # Outside tmux
#         if tmux has-session -t "$selected_name" 2>/dev/null; then
#             tmux attach-session -t "$selected_name"
#         else
#             tmux new-session -s "$selected_name" -c "$selected"
#         fi
#     fi
# fi
