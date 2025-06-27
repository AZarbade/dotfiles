#!/bin/bash

# Get a list of PDFs using fd
mapfile -t pdfs < <(fd . --extension pdf ~/Documents ~/Downloads ~/personal 2>/dev/null)

# Map filenames to full paths, handle duplicates
declare -A pdf_map
choices=()

for path in "${pdfs[@]}"; do
    name=$(basename "$path")
    key="$name"
    i=1
    while [[ -n "${pdf_map[$key]}" ]]; do
        key="${name} ($i)"
        ((i++))
    done
    pdf_map["$key"]="$path"
    choices+=("$key")
done

# Launch tofi
selection=$(printf '%s\n' "${choices[@]}" | tofi)

# Open the selected file
[[ -n "$selection" ]] && xdg-open "${pdf_map[$selection]}"
