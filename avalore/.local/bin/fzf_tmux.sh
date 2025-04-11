#!/bin/bash

dirs=("$HOME/personal" "$HOME/dotfiles")  # Default directories
cache_file="$HOME/.dir_cache"
log_file="$HOME/.dir_cache_log"

# Check for required commands
for cmd in fd fzf tmux; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "$cmd is required but not installed. Aborting."; exit 1; }
done

# Log function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

update_cache() {
    # Log the cache update action
    log_message "Updating cache"
    
    printf "%s\n" "${dirs[@]}" > "$cache_file"
    fd --hidden --type d . "${dirs[@]}" 2>/dev/null | sort -u >> "$cache_file"
    
    log_message "Cache updated"
    echo "Cache updated."
}

# Force update with --update flag
if [[ "$1" == "--update" ]]; then
    update_cache
    exit 0
fi

# Always update the cache before proceeding
update_cache

# Use fzf to select from the cached list
selected=$(cat "$cache_file" | fzf \
    --preview "tree -L 2 {}" \
    --preview-window right:50%:wrap \
    --prompt "Select directory or session: " \
    --header "↑↓:Navigate │ Enter:Select │ Ctrl-C:Cancel " \
    --border rounded
)

# Exit gracefully if nothing was selected
[ -z "$selected" ] && { echo "No directory selected. Exiting."; exit 0; }

echo "Selected directory: $selected"
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
