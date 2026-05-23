#!/bin/bash

# Path to your themes and waybar config
THEME_DIR="$HOME/.config/themes"
WAYBAR_COLOR_FILE="$HOME/.config/waybar/colors.css"
ROFI_COLOR_FILE="$HOME/.config/rofi/colors.rasi"
CURRENT_THEME_FILE="$HOME/.config/hypr/switchers/current-theme.txt"
KITTY_COLOR_FILE="$HOME/.config/kitty/colors.conf"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
HYPR_COLOR_FILE="$HOME/.config/hypr/modules/colors.conf"
ROFI_THEME="$HOME/.config/rofi/launchers/type-1/style-3.rasi"
TRANSITION=$(cat ~/.config/hypr/switchers/current-transition.txt)
HYPRLOCK_THEME_FILE="$HOME/.config/hypr/switchers/hyprlocktheme.conf"
ZEN_COLOR_FILE="$HOME/.config/zen/colors.css"
SWAYNC_COLOR_FILE="$HOME/.config/swaync/colors.css"

# 1. Get list of themes (folder names)
themes=$(ls "$THEME_DIR")

# 2. Show Rofi menu
selected_theme=$(echo "$themes" | rofi -dmenu -p "Select Theme" -i -theme "$ROFI_THEME")

# 3. If a theme is selected, apply it
if [ -n "$selected_theme" ]; then
    # Path to the source colors.css and wallpaper
    SRC_WAYBAR_COLORS="$THEME_DIR/$selected_theme/waybar/colors.css"
    SRC_WALLPAPER="$THEME_DIR/$selected_theme/wallpaper.png"
    SRC_ROFI_COLORS="$THEME_DIR/$selected_theme/rofi/colors.rasi"
    SRC_CURRENT_THEME="$THEME_DIR/$selected_theme/current-theme.txt"
    SRC_KITTY_COLORS="$THEME_DIR/$selected_theme/kitty/colors.conf"
    case $selected_theme in
    	"Gruvbox")
        	VS_THEME="Gruvbox Dark Medium"
        	;;
    	"Catppuccin")
        	VS_THEME="Catppuccin Mocha"
        	;;
    	"Onedark")
        	VS_THEME="One Dark Pro Darker"
        	;;
    	"E-ink")
                VS_THEME="Monochrome Dark Amplified" 
        	;;
	"Everforest")
		VS_THEME="Everforest Pro Dark Vibrant"
		;;
	"Nord")
		VS_THEME="Nord"
		;;
	"Emerald")
		VS_THEME="Dark Green Jungle"
		;;
	"Rose Pine")
		VS_THEME="Rosé Pine Moon"
		;;

	esac
    SRC_HYPR_COLORS="$THEME_DIR/$selected_theme/hypr/colors.conf"
    SRC_HYPRLOCK_THEME="$THEME_DIR/$selected_theme/hyprlock/hyprlocktheme.conf"
    SRC_ZEN_COLORS="$THEME_DIR/$selected_theme/zen/colors.css"

    # Copy the colors.css to your active waybar directory
    if [ -f "$SRC_WAYBAR_COLORS" ]; then
        cp "$SRC_WAYBAR_COLORS" "$WAYBAR_COLOR_FILE"
	cp "$SRC_WAYBAR_COLORS" "$SWAYNC_COLOR_FILE"
        ./.config/waybar/scripts/launch.sh
    fi

    # Copy the colors.rasi file to rofi directory
    if [ -f "$SRC_ROFI_COLORS" ]; then
        cp "$SRC_ROFI_COLORS" "$ROFI_COLOR_FILE"
    fi

    # Changing current theme txt file
    if [ -f "$SRC_CURRENT_THEME" ]; then
	    cp "$SRC_CURRENT_THEME" "$CURRENT_THEME_FILE"
    fi

    if [ -f "$SRC_KITTY_COLORS" ]; then
        cp "$SRC_KITTY_COLORS" "$KITTY_COLOR_FILE"
        # refresh all kitty terminals in real time 
        pkill -USR1 kitty
    fi

    if [ -f "$VSCODE_SETTINGS" ]; then
	    sed -i "/\"workbench.colorTheme\":/s/: \".*\"/: \"$VS_THEME\"/" "$VSCODE_SETTINGS"
    fi

    if [ -f "$SRC_HYPR_COLORS" ]; then
        cp "$SRC_HYPR_COLORS" "$HYPR_COLOR_FILE"
    fi

    if [ -f "$SRC_HYPRLOCK_THEME" ]; then
	cp "$SRC_HYPRLOCK_THEME" "$HYPRLOCK_THEME_FILE"
    fi

    if [ -f "$SRC_ZEN_COLORS" ]; then
	cp "$SRC_ZEN_COLORS" "$ZEN_COLOR_FILE"
    fi

    # Apply the wallpaper (assuming you use swww)
    if [ -f "$SRC_WALLPAPER" ]; then
	awww img "$SRC_WALLPAPER" --transition-type "$TRANSITION" --transition-fps 144 --transition-duration 2 --transition-angle 70
    fi

    notify-send -r 997 "Theme Successfully Applied" "Current Theme: $selected_theme"

fi
