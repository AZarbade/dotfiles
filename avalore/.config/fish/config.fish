# based on: https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish

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
abbr -a ls 'eza -l'
abbr -a lsl 'eza -la'
abbr -a tree 'eza --tree'
abbr -a tm 'tmux -u'
abbr -a btop 'btop --utf-force'
abbr -a p 'sudo pacman -S'
abbr -a up 'sudo pacman -Syu'
abbr -a bkms 'nvim $HOME/.bookmarks'
abbr -a sys 'sudo systemctl'

# Media abbreviations
abbr -a vol 'pulsemixer'
abbr -a blue 'bluetui'

# Git abbreviations
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a gm 'git merge --no-ff'
abbr -a gg 'git-graph'
abbr -a gp 'git push github main && git push gitea main'

# Embedded bindings
abbr -a get_esprs '. $HOME/export-esp.sh'
abbr -a get_idf '. $HOME/personal/esp_box/esp-idf/export.fish'
abbr -a idf 'idf.py'

# fzf binds
bind -M insert \cp '$HOME/dotfiles/avalore/.local/bin/fzf_tmux.sh'

# Greetings function
function fish_greeting
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
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
