#!/bin/bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$DIR/.common.sh"

for variant in "${VARIANTS[@]}"; do
    echo "https://github.com/flathub/org.gtk.Gtk3theme.Catppuccin-${variant}/compare/${1}?expand=1"
done
