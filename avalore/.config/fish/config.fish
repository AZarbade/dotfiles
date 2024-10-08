# credit: https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish

set -g fish_greeting
set -g fish_user_key_bindings

set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.platformio/penv/bin $PATH
fish_add_path /opt/nvim-linux64/bin
atuin init fish | source

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# Abbreviations
abbr -a ls 'exa -l'
abbr -a lsl 'exa -la'
abbr -a tree 'exa --tree'
abbr -a tm 'tmux -u'
abbr -a btop 'btop --utf-force'
abbr -a p 'sudo pacman'
abbr -a up 'sudo pacman -Syu'
abbr -a bkms 'nvim $HOME/dotfiles/bookmarks'

# Media abbreviations
abbr -a vol 'pulsemixer'
abbr -a blue 'bluetui'

# Git abbreviations
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a gm 'git merge --no-ff'
abbr -a gg 'git-graph'

# Obsidian setup
abbr -a oo obsidian_notes
function obsidian_notes
    cd ~/personal/notes
    nvim
end

# Embedded bindings
abbr -a get_esprs '. $HOME/export-esp.sh'
abbr -a get_idf '. $HOME/personal/esp_box/esp-idf/export.fish'
abbr -a idf 'idf.py'

# fzf binds
bind -M insert \cp fzf_tmux

# Greetings function
function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')

	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E '/home|dev/(xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}'
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
        fd --hidden --type d --max-depth 3 . $dirs
    end | sort | uniq | fzf \
        --preview 'exa --tree {} | head -200' \
        --preview-window right:50%:wrap \
        --prompt "Select directory: " \
        --header "↑↓:Navigate │ Enter:Select │ Ctrl-C:Cancel " \
        --border rounded \
        --height 40% \
		--color 'bg:#1d2021,fg:#fbf1c7,hl:#fabd2f'\
        --color 'fg+:#fbf1c7,bg+:#3c3836,hl+:#fabd2f'\
        --color 'info:#83a598,prompt:#bdae93,pointer:#fb4934'\
        --color 'marker:#fb4934,spinner:#fabd2f,header:#665c54'\
        --color 'border:#504945,preview-bg:#1d2021')
    
    if test -z "$selected"
        return
    end
    set -l selected_name (basename "$selected" | tr . _)
    set -l session_exists (tmux list-sessions | grep $selected_name)
    
    if test -n "$TMUX"
        if test -n "$session_exists"
            tmux switch-client -t $selected_name
        else
            tmux new-session -d -s $selected_name -c "$selected"
            tmux switch-client -t $selected_name
        end
    else
        if test -n "$session_exists"
            tmux attach-session -t $selected_name
        else
            tmux new-session -s $selected_name -c "$selected"
        end
    end
end

# Fish prompt
function fish_prompt
	# Ensure pywal colors are loaded
    if test -e ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end

	set_color $color1
	echo -n "["(date "+%H:%M")"] "
	set_color $color4
	echo -n (whoami)
	echo -n  "@"
	echo -n (hostnamectl hostname)
	if [ $PWD != $HOME ]
		set_color $color4
		echo -n ':'
		set_color $color15
		echo -n (basename $PWD)
	end
	set_color $color11
	printf '%s ' (__fish_git_prompt)
	set_color $color8
	echo -n '| '
	set_color $color7
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3
