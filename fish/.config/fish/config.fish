set -g fish_greeting
set -g fish_user_key_bindings

set -x PATH $HOME/.local/bin $PATH
fish_add_path /opt/nvim-linux64/bin
atuin init fish | source

# Abbreviations
abbr -a ls exa -l
abbr -a lsl exa -la
abbr -a tree exa --tree
abbr -a tm tmux -u
abbr -a btop btop --utf-force

# Media abbreviations
abbr -a vol pulsemixer
abbr -a blue bluetui

# Git abbreviations
abbr -a gs git status
abbr -a gc git commit
abbr -a gm git merge --no-ff
abbr -a gg git-graph

# Obsidian setup
abbr -a oo obsidian_notes

function obsidian_notes
    cd ~/personal/notes
    nvim
end

# Embedded bindings
abbr -a get_esprs . $HOME/export-esp.sh
abbr -a get_idf . $HOME/personal/esp_box/esp-idf/export.fish
abbr -a idf idf.py

# fzf binds
bind \cp fzf_tmux

# Greetings function
function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	echo -e " \\e[1mNetwork:\\e[0m"
	echo
	# http://tdt.rocks/linux_network_interface_naming.html
	echo -ne (\
		ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
			sort | \
			column -t -R1 | \
			# public addresses are underlined for visibility \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
			# private addresses are not \
			sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
			# unknown interfaces are cyan \
			sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
			# ethernet interfaces are normal \
			sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
			# wireless interfaces are purple \
			sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
			# wwan interfaces are yellow \
			sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
			sed 's/$/\\\e[0m/' | \
			sed 's/^/\t/' \
		)
	echo
end

# Vim Mode
function fish_user_key_bindings
  fish_vi_key_bindings
end


# Function for fzf (directory in tmux session)
function fzf_tmux
    set -l dirs ~/personal ~/dotfiles # Add more directories as needed
    set -l selected (begin
        printf "%s\n" $dirs
        fd --hidden --type d . $dirs
    end | sort | uniq | fzf --preview "ls -lha {}")
    
    if test -z "$selected"
        return
    end

    set -l selected_name (basename "$selected" | tr . _)

    if test -n "$TMUX"
        # If inside tmux, create a new session and switch to it
        tmux new-session -d -s $selected_name -c "$selected"
        tmux switch-client -t $selected_name
    else
        # If not in tmux, create new session and attach to it
        tmux new-session -s $selected_name -c "$selected"
    end
end
