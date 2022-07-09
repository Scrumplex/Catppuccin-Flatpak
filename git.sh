#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DIR/.common.sh"

set -x

for variant in "${VARIANTS[@]}"; do
    target_dir="$DIR/${THEME_NAME_BASE}${variant}"

    git -C "$target_dir" "$@"
done
