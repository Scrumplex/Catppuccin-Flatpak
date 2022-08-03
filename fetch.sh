#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DIR/.common.sh"

set -x

temp_dir=$(mktemp -d)

for variant in "${VARIANTS[@]}"; do
    variant_file="$DIR/data/$variant.json"
    variant_zip="$temp_dir/$variant.zip"

    curl -Lo "$variant_zip" "https://github.com/catppuccin/gtk/releases/download/$GIT_TAG/Catppuccin-$variant.zip"
    cat > "$variant_file" <<EOF
{
    "theme": {
        "name": "Catppuccin-$variant",
        "nameFriendly": "Catppuccin ($variant)",
        "nameShort": "$variant",
        "sha256": "$(sha256sum "$variant_zip" | cut -d" " -f1)"
    }
}
EOF
done

rm -rfv "$temp_dir"
