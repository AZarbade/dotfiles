#!/bin/bash

# Define search lists
dirs=("$HOME/personal" "$HOME/dotfiles")
dir_list=$(printf "%s\n" "${dirs[@]}" && fd --hidden --type d . "${dirs[@]}" 2>/dev/null | sort | uniq)
 
# Use fzf to select from the combined list
selected=$(echo "$dir_list" | fzf \
	--preview "exa --tree -L 2 {}" \
	   --preview-window right:50%:wrap \
	   --prompt "Select directory or session: " \
	   --header "↑↓:Navigate │ Enter:Select │ Ctrl-C:Cancel " \
	   --border rounded \
	   --color "bg:#1d2021,fg:#fbf1c7,hl:#fabd2f"\
	   --color "fg+:#fbf1c7,bg+:#3c3836,hl+:#fabd2f"\
	   --color "info:#83a598,prompt:#bdae93,pointer:#fb4934"\
	   --color "marker:#fb4934,spinner:#fabd2f,header:#665c54"\
	   --color "border:#504945,preview-bg:#1d2021")

# Exit if nothing was selected
[ -z "$selected" ] && exit 0

selected_name=$(basename "$selected" | tr . _)
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
