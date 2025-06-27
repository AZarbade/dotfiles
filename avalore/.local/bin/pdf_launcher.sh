#!/bin/bash

mapfile -t pdfs < <(fd . --extension pdf ~/Documents ~/Downloads ~/personal 2>/dev/null)

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

selection=$(printf '%s\n' "${choices[@]}" | tofi)
zathura "${pdf_map[$selection]}" &
