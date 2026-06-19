#!/bin/bash

ACTIVE_THEME=$(cat ~/.config/hypr/switchers/current-theme.txt)

WALL_DIR="$HOME/.config/hypr/Wallpapers/$ACTIVE_THEME"
ROFI_STYLE="$HOME/.config/rofi/launchers/type-3/style-6.rasi"
TRANSITION=$(cat ~/.config/hypr/switchers/current-transition.txt)

mapfile -t files < <(ls "$WALL_DIR")
list=""
for file in "${files[@]}"; do
    list+="$file\0icon\x1f$WALL_DIR/$file\n"
done

# Launch Rofi
choice=$(echo -e "$list" | rofi -dmenu -i -p "Select Wallpaper: " -theme "$ROFI_STYLE" -display-columns 1)


if [ -n "$choice" ]; then
    FULL_PATH="$WALL_DIR/$choice"
    if [ -f "$FULL_PATH" ]; then
        awww img "$WALL_DIR/$choice" --transition-type "$TRANSITION" --transition-fps 144 --transition-duration 2 --transition-angle 70
	notify-send -r 998 "Wallpaper Applied Successfully" "Current Wallpaper Theme: $ACTIVE_THEME"
    else
        notify-send "Error" "Wallpaper not found: $FULL_PATH"
    fi
fi
