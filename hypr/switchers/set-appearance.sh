#!/bin/bash

ROFI_STYLE="$HOME/.config/rofi/launchers/type-1/style-3.rasi"

options="Themes\nWallpapers\nWallpaper Transitions\nWaybar\nFonts"

choice=$(echo -e "$options" | rofi -dmenu -i -p "Appearance: " -theme "$ROFI_STYLE")

if [ -n "$choice" ]; then
	case $choice in
    "Themes")
        ~/.config/hypr/switchers/set-theme.sh
        ;;
    "Wallpapers")
        ~/.config/hypr/switchers/set-wallpaper.sh
        ;;
    "Wallpaper Transitions")
        ~/.config/hypr/switchers/set-wallpaper-transition.sh
        ;;
    "Waybar")
        ~/.config/hypr/switchers/set-waybar.sh
        ;;
    "Fonts")
        font-manager &
        ;;
		esac
fi
