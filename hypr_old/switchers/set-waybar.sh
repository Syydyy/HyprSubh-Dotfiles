#!/bin/bash

WAYBAR_DIR="$HOME/.config/waybar"
THEMES_DIR="$WAYBAR_DIR/themes"
ROFI_STYLE="$HOME/.config/rofi/launchers/type-1/style-3.rasi"

# Get list of theme folders
themes=$(ls "$THEMES_DIR")

# Select theme via Rofi
choice=$(echo -e "$themes" | rofi -dmenu -i -p "Waybar Style: " -theme "$ROFI_STYLE")

if [ -n "$choice" ]; then
    # Define source paths clearly
    SRC_CONFIG="$THEMES_DIR/$choice/config.jsonc"
    SRC_STYLE="$THEMES_DIR/$choice/style.css"

    # Check if the source files actually exist before copying
    if [ ! -f "$SRC_CONFIG" ]; then
        echo "Error: Source config not found at $SRC_CONFIG"
    elif [ ! -f "$SRC_STYLE" ]; then
        echo "Error: Source style not found at $SRC_STYLE"
    else
        # Perform the copy with 'v' for verbose output
	cp -f "$SRC_CONFIG" "$WAYBAR_DIR/config.jsonc"
        cp -f "$SRC_STYLE" "$WAYBAR_DIR/style.css"
        
        # Now launch
        bash "$HOME/.config/waybar/scripts/launch.sh"
    fi
fi
