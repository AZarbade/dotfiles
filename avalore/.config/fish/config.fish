# based on: https://github.com/jonhoo/configs/blob/master/shell/.config/fish/config.fish

set -g fish_greeting
set -g fish_user_key_bindings

set -x PATH $HOME/.local/bin $PATH
set -x MANPAGER "nvim -c 'Man!' -o -"
fish_add_path /opt/nvim-linux64/bin
fish_add_path /opt/asdf-vm/asdf.fish
atuin init fish | source

# Abbreviations
abbr -a ls 'ls -l'
abbr -a lsl 'ls -la'
abbr -a tree 'tree -L 2'
abbr -a tm 'tmux -u'
abbr -a sys 'sudo systemctl'
abbr -a untar 'tar -xvzf '

# Git abbreviations
abbr -a gs 'git status'
abbr -a gc 'git commit'
abbr -a gm 'git merge --no-ff'
abbr -a gg 'git-graph'
abbr -a gp 'git push'

# Embedded bindings
abbr -a get_esprs '. $HOME/export-esp.sh'
abbr -a get_idf '. $HOME/esp-idf/export.fish'
abbr -a idf 'idf.py'

# Replace with your actual FQBN and port
set -gx ARDUINO_FQBN esp32:esp32:esp32c6
set -gx ARDUINO_PORT /dev/ttyACM0

alias ardcompile='arduino-cli compile --fqbn $ARDUINO_FQBN'
alias ardupload='arduino-cli upload -p $ARDUINO_PORT --fqbn $ARDUINO_FQBN'

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

# Fish colors
set -gx color1 "#7dc982"   # Soft Green (Prompt Time/User/Separator)
set -gx color4 "#9ee0a6"   # Bright Green (User/Host)
set -gx color15 "#98c379"  # Mocha Green (Current Directory)
set -gx color11 "#61afef"  # Blue (Git branch info)
set -gx color8 "#cdd6f4"   # Pale Gray (Git metadata)
set -gx color7 "#56b6c2"   # Cyan (Branch status/extra info)
set -gx color2 "#e0fbe3"   # Very Light Mint (Not used here, optional)
set -gx color3 "#cba6f7"   # Lavender (Unused, optional)

# Fish prompt
function fish_prompt -d "Write out the prompt"
    set_color $color1
    echo -n "["(date "+%H:%M")"] "

    set_color $color4
    echo -n (whoami)"@"(hostnamectl hostname)

    if [ $PWD != $HOME ]
        set_color $color4
        echo -n ":"
        set_color $color15
        echo -n (basename $PWD)
    end

    set_color $color11
    printf '%s ' (__fish_git_prompt)

    set_color $color8
    echo -n "| "

    set_color $color7
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3
