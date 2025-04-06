# based on: https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish

set -g fish_greeting
set -g fish_user_key_bindings

set -x DISPLAY 172.20.32.1:0
set -x PATH $HOME/.local/bin $PATH
fish_add_path /opt/nvim-linux64/bin

# Abbreviations
abbr -a ls 'ls -l'
abbr -a lsl 'ls -al'
abbr -a tree 'tree -L 2'
abbr -a tm 'tmux -u'
abbr -a sys 'sudo systemctl'

# Git abbreviations
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a gm 'git merge --no-ff'
abbr -a gg 'git-graph'
abbr -a gp 'git push'

# Embedded bindings
abbr -a get_esprs '. $HOME/export-esp.sh'
abbr -a get_idf '. $HOME/personal/esp_box/esp-idf/export.fish'
abbr -a idf 'idf.py'

# fzf binds
bind -M insert \cp '$HOME/dotfiles/wsl_arch/.local/bin/fzf_tmux.sh'

# Greetings function
function fish_greeting
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127\.0\.0\.1$' | head -n 1 | awk '{print " \\\\e[1mIP Address: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo
end

# Vim Mode
function fish_user_key_bindings
  fish_vi_key_bindings
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
