#!/bin/bash

# Define where to save the preference
TRANS_FILE="$HOME/.config/hypr/switchers/current-transition.txt"

# List of swww transition types
options="random\nany\nwipe\nwave\ngrow\ncenter\nouter\nleft\nright\ntop\nbottom\nsimple\nnone"

# Pick a transition using Rofi
# Using your style-6 for consistency
ROFI_STYLE="$HOME/.config/rofi/launchers/type-1/style-3.rasi"
choice=$(echo -e "$options" | rofi -dmenu -i -p "Transition Type: :" -theme "$ROFI_STYLE")

if [ -n "$choice" ]; then
    echo "$choice" > "$TRANS_FILE"
fi
