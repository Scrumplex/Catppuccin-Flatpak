#!/bin/bash

COMMON_FILE="data/_common.json"
THEME_NAME_BASE="Catppuccin-"

VARIANTS=(blue green orange pink purple red teal yellow)

generate_data() {
    jq -s ".[0] * .[1]" "$COMMON_FILE" "$1"
}

for variant in "${VARIANTS[@]}"; do
    variant_file="data/$variant.json"

    if [ -f "$variant_file" ]; then
        for f in templates/*; do
            target_file="${f//$THEME_NAME_BASE/${THEME_NAME_BASE}${variant}}"
            target_file=$(basename "$target_file")
            target_file="${target_file%.j2}"
            target_dir="${THEME_NAME_BASE}${variant}"
            generate_data "$variant_file" | j2 -f json "$f" > "$target_dir/$target_file"
        done
    else
        echo "Skipping $variant"
    fi
done
