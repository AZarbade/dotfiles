set -g fish_greeting
set -g fish_vi_key_bindings

set -x PATH $HOME/.local/bin $PATH
fish_add_path /opt/nvim-linux64/bin
atuin init fish | source

# Abbreviations
abbr -a ls exa -l
abbr -a lsl exa -la
abbr -a tree exa --tree
abbr -a tm tmux -u
abbr -a btop btop --utf-force

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

# SSH abbreviations
abbr -a homelab ssh onyx@homelab.local
abbr -a broker ssh noir@broker.local

# Embedded bindings
abbr -a get_esprs . $HOME/export-esp.sh
abbr -a get_idf . $HOME/personal/esp_box/esp-idf/export.fish
abbr -a idf idf.py

# Poetry (python) helpers
abbr -a pos poetry shell
abbr -a por poetry run python

# fzf binds
bind \cp fzf_tmux

# Greetings function
function fish_greeting
    neofetch
end

# Function for fzf (directory in tmux session)
function fzf_tmux
    set -l dirs ~/personal ~/dotfiles # Add more directories as needed
    set -l selected (begin
        printf "%s\n" $dirs
        fdfind --hidden --type d . $dirs
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
