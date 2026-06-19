#!/bin/bash

# Path to your themes and waybar config
THEME_DIR="$HOME/.config/hypr/themes"
CURRENT_THEME_FILE="$HOME/.config/hypr/switchers/current-theme.txt"
WAYBAR_COLOR_FILE="$HOME/.config/waybar/colors.css"
ROFI_COLOR_FILE="$HOME/.config/rofi/colors.rasi"
KITTY_COLOR_FILE="$HOME/.config/kitty/colors.conf"
VSCODE_SETTINGS="$HOME/.config/VSCodium/User/settings.json"
HYPR_COLOR_FILE="$HOME/.config/hypr/modules/colors.lua"
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
                VS_THEME="baseline" 
        	;;
        "Everforest")
            VS_THEME="Everforest Night Hard"
            ;;
        "Nord")
            VS_THEME="Nord"
            ;;
        "Emerald")
            VS_THEME="Ravenwood Dark"
            ;;
        "Rose Pine")
            VS_THEME="Rosé Pine Moon"
            ;;

	esac
    SRC_HYPR_COLORS="$THEME_DIR/$selected_theme/hypr/colors.lua"
    SRC_HYPRLOCK_THEME="$THEME_DIR/$selected_theme/hyprlock/hyprlocktheme.conf"
    SRC_ZEN_COLORS="$THEME_DIR/$selected_theme/zen/colors.css"

    # Copy the colors.css to your active waybar directory
    if [ -f "$SRC_WAYBAR_COLORS" ]; then
        cp "$SRC_WAYBAR_COLORS" "$WAYBAR_COLOR_FILE"
	cp "$SRC_WAYBAR_COLORS" "$SWAYNC_COLOR_FILE"
        $HOME/.config/waybar/scripts/launch.sh
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


    ACTIVE_THEME=$(cat ~/.config/hypr/switchers/current-theme.txt)
    WALLPAPER_DIR="$HOME/.config/hypr/Wallpapers/$ACTIVE_THEME"

    # Apply the wallpaper (assuming you use swww)
    if [ -d "$WALLPAPER_DIR" ]; then
        HISTORY_FILE="$WALLPAPER_DIR/.wallpaper_history"
        
        # 1. Get all available wallpapers
        all_walls=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f ! -name ".*")
        
        # 2. Touch the history file if it doesn't exist
        touch "$HISTORY_FILE"
        
        # 3. Find wallpapers that HAVEN'T been used yet
        # We use 'grep -Fvxf' to filter out paths already inside the history file
        available_walls=$(echo "$all_walls" | grep -Fvxf "$HISTORY_FILE")
        
        # 4. If all wallpapers have been used, reset the history!
        if [ -z "$available_walls" ]; then
            > "$HISTORY_FILE" # Clears the file
            available_walls="$all_walls"
        fi
        
        # 5. Pick one randomly from the remaining pool
        RANDOM_WALLPAPER=$(echo "$available_walls" | shuf -n 1)
        
        if [ -n "$RANDOM_WALLPAPER" ]; then
            # 6. Log this wallpaper so it isn't picked again
            echo "$RANDOM_WALLPAPER" >> "$HISTORY_FILE"
            
            # 7. Apply it
            awww img "$RANDOM_WALLPAPER" --transition-type "$TRANSITION" --transition-fps 144 --transition-duration 2 --transition-angle 70
        fi
    fi

    notify-send -r 997 "Theme Successfully Applied" "Current Theme: $selected_theme"

fi
