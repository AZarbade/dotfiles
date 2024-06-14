set -g fish_greeting
set -g fish_vi_key_bindings
# set -g fish_default_key_bindings

fish_add_path /opt/nvim-linux64/bin
fish_add_path /bin/exercism
source "$HOME/.asdf/asdf.fish"
atuin init fish | source

# Abbreviations
abbr -a ls exa -l
abbr -a lsl exa -la
abbr -a tree exa --tree
abbr -a tm tmux -u
abbr -a spd speedtest-rs
abbr -a btop btop --utf-force
abbr -a gg git-graph

# SSH abbreviations
abbr -a homelab ssh onyx@homelab.local
abbr -a broker ssh noir@broker.local

# Embedded Rust bindings
abbr -a get_esprs . $HOME/export-esp.sh
abbr -a get_idf . $HOME/personal/embedded_rtos/esp-idf/export.fish

# Poetry helpers
abbr -a pos poetry shell
abbr -a por poetry run python

# fzf binds
bind \cp fzf_cd
bind \ce fzf_nvim

# Greetings function
function fish_greeting
    neofetch
end

# Function for fzf (directory)
function fzf_cd
    set -l dir (find ~/personal/ -type d | fzf --preview "ls -lha {}")
    if test -n "$dir"
        cd "$dir"
        commandline -f repaint
    end
end

# Function for fzf (files)
function fzf_nvim
    set -l file (find ~/personal/ -type f | fzf --preview "bat --style=numbers --color=always --line-range :500 {}")
    if test -n "$file"
        nvim "$file"
    end
end
