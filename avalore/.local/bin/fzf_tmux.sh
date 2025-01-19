#!/bin/bash

dirs=("$HOME/personal" "$HOME/dotfiles") # Add more if needed
cache_file="$HOME/.dir_cache"

update_cache() {
    printf "%s\n" "${dirs[@]}" > "$cache_file"
    fd --hidden --type d . "${dirs[@]}" 2>/dev/null | sort -u >> "$cache_file"
	echo "Cache updated."
}

# Force update
if [[ "$1" == "--update" ]]; then
    update_cache
    exit 0
fi

# Check if cache exists and is less than 1 hour old
if [[ ! -f "$cache_file" ]] || [[ $(find "$cache_file" -mmin +60) ]]; then
    update_cache
fi

# Use fzf to select from the cached list
selected=$(cat "$cache_file" | fzf \
    --preview "eza --tree -L 2 {}" \
    --preview-window right:50%:wrap \
    --prompt "Select directory or session: " \
    --header "↑↓:Navigate │ Enter:Select │ Ctrl-C:Cancel " \
	--border rounded
)

# Exit if nothing was selected
[ -z "$selected" ] && exit 0

selected_name=$(basename "$selected" | tr . _)

if [ -n "$TMUX" ]; then
    # Inside tmux
    tmux has-session -t "$selected_name" 2>/dev/null && \
        exec tmux switch-client -t "$selected_name"
    
    tmux new-session -d -s "$selected_name" -c "$selected"
    exec tmux switch-client -t "$selected_name"
else
    # Outside tmux
    tmux has-session -t "$selected_name" 2>/dev/null && \
        exec tmux attach-session -t "$selected_name"
    
    exec tmux new-session -s "$selected_name" -c "$selected"
fi
