#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DIR/.common.sh"

set -x

generate_data() {
    jq -s ".[0] * .[1]" "$DIR/$COMMON_FILE" "$1"
}

for variant in "${VARIANTS[@]}"; do
    variant_file="$DIR/data/$variant.json"

    if [ -f "$variant_file" ]; then
        for f in templates/*; do
            target_file="${f//$THEME_NAME_BASE/${THEME_NAME_BASE}${variant}}"
            target_file=$(basename "$target_file")
            target_file="${target_file%.j2}"
            target_dir="$DIR/${THEME_NAME_BASE}${variant}"
            generate_data "$variant_file" | j2 -f json "$f" > "$target_dir/$target_file"
        done
    else
        echo "Skipping $variant"
    fi
done
