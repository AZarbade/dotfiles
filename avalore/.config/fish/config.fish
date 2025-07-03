# ─── ENVIRONMENT ──────────────────────────────────────────────
set -g fish_greeting
set -g fish_user_key_bindings

set -x PATH $HOME/.local/bin $PATH
set -x MANPAGER "nvim -c 'Man!' -o -"

fish_add_path /opt/nvim-linux64/bin
fish_add_path /opt/asdf-vm/asdf.fish

atuin init fish | source

# ─── ABBREVIATIONS ────────────────────────────────────────────
abbr -a ls 'ls -l'
abbr -a lsl 'ls -la'
abbr -a tree 'tree -L 2'
abbr -a tm 'tmux -u'

# ESP/Embedded
abbr -a get_esprs '. $HOME/export-esp.sh'
abbr -a get_idf '. $HOME/esp-idf/export.fish'
abbr -a idf 'idf.py'

# Arduino
set -gx ARDUINO_FQBN esp32:esp32:esp32c6
set -gx ARDUINO_PORT /dev/ttyACM0
set -gx ARDUINO_BUADRATE 115200

abbr -a ardcompile 'arduino-cli compile --fqbn $ARDUINO_FQBN'
abbr -a ardupload 'arduino-cli upload -p $ARDUINO_PORT --fqbn $ARDUINO_FQBN'
abbr -a rdmonitor 'arduino-cli monitor -p $ARDUINO_PORT --config $ARDUINO_BUADRATE'

# PCB Design
abbr -a eda 'easyeda2kicad --full --lcsc_id='

# ─── FZF Bindings ─────────────────────────────────────────────
bind -M insert \cp '$HOME/dotfiles/avalore/.local/bin/fzf_tmux.sh'

# ─── GREETING ─────────────────────────────────────────────────
function fish_greeting
    printf " \e[1mOS: \e[0;32m%s\e[0m\n" (uname -ro)
    printf " \e[1mUptime: \e[0;32m%s\e[0m\n" (uptime -p | sed 's/^up //')
    printf " \e[1mHostname: \e[0;32m%s\e[0m\n" (uname -n)
    echo
end

# ─── VI MODE ──────────────────────────────────────────────────
function fish_user_key_bindings
    fish_vi_key_bindings
end

# ─── COLORS (Gruvbox Dark) ─────────────────────────────────────
set -gx color1  "#fabd2f"   # Time/username (yellow)
set -gx color4  "#83a598"   # Hostname (blue)
set -gx color15 "#b8bb26"   # Current dir (green)
set -gx color11 "#fe8019"   # Git branch (orange)
set -gx color8  "#d3869b"   # Git metadata (purple)
set -gx color7  "#fb4934"   # Git status symbols (red)

# ─── PROMPT ───────────────────────────────────────────────────
function fish_prompt --description "Prompt"
    # Time
    set_color $color1
    printf '[%s] ' (date "+%H:%M")

    # User and host
    set_color $color4
    printf '%s@%s' (whoami) (hostnamectl hostname)

    # Path
    if test $PWD != $HOME
        set_color $color4
        echo -n ":"
        set_color $color15
        echo -n (basename $PWD)
    end

    # Git info
    set_color $color11
    printf ' %s' (__fish_git_prompt)

    # Separator
    set_color $color8
    echo -n " | "

    # Final prompt symbol
    set_color $color7
end

# ─── GIT PROMPT CONFIG ────────────────────────────────────────
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 10
