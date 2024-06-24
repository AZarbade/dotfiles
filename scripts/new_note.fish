#!/usr/bin/env fish

if test -z "$argv[1]"
    echo "Error: A file name must be set, e.g. on \"the wonderful thing about tiggers\"."
    exit 1
end

set file_name (echo "$argv[1]" | tr ' ' '-')
set formatted_file_name (date "+%Y-%m-%d")_$file_name.md

cd "$HOME/personal/avalore/" || exit

touch "inbox/$formatted_file_name"
nvim "inbox/$formatted_file_name"
