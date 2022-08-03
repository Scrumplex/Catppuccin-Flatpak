#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DIR/.common.sh"

set -x

generate_data() {
    jq -s ".[0] * .[1]" "$DIR/$COMMON_FILE" "$1"
}

temp_dir="$(mktemp -d)"

for variant in "${VARIANTS[@]}"; do
    variant_file="$DIR/data/$variant.json"

    if [ -d "$DIR/${THEME_NAME_BASE}${variant}" ]; then
        echo "Skipping $variant"
    else
        pushd "$temp_dir" || exit 1
        git clone --branch "new-pr" "$MAINTAINER_FLATHUB" "${THEME_NAME_BASE}${variant}"
        git -C "${THEME_NAME_BASE}${variant}" checkout -b "${THEME_NAME_BASE}${variant}"

        for f in "$DIR"/templates/*; do
            target_file="${f//$THEME_NAME_BASE/${THEME_NAME_BASE}${variant}}"
            target_file=$(basename "$target_file")
            target_file="${target_file%.j2}"
            target_dir="$temp_dir/${THEME_NAME_BASE}${variant}"
            generate_data "$variant_file" | j2 -f json "$f" > "$target_dir/$target_file"
        done

        git -C "${THEME_NAME_BASE}${variant}" add .
        git -C "${THEME_NAME_BASE}${variant}" commit -m "initial commit"
        git -C "${THEME_NAME_BASE}${variant}" push -u origin "${THEME_NAME_BASE}${variant}"
    fi
done
