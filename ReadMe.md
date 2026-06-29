# A Basic Guide to my Hyprland Setup
*Note: Updated to latest lua version hyprland 0.55*

## Some important keybinds:

* Open kitty terminal - Super + T
* Close a window - Super + Q
* Open browser (Firefox) - Super + B
* Open app launcher (Rofi) - Super + R
* Open vscode - Super + V
* Open Clipboard - Super + Shift + V
* Open Custom theme switcher - Super + RETURN
* Open Custom wallpaper switcher - Super + W
* Open waybar switcher - Super + Shift + W
* Open custom wallpaper transition switcher - Super + Alt + W
* Open Appearance menu (All switchers are available here) - Super + A
* Logout and close all apps - Super + CTRL + P


You can change these keybindings in ~/.config/hypr/modules/keybinds.lua

## Some basic dependencies: 
* hyprland
* kitty
* waybar
* waybar-update
* rofi
* swaync
* swayosd
* hyprlock
* hypridle
* awww
* firefox
* vscode

## 1. Main Files:

### A. If you use vscode:

Then to match custom theme switcher to your vscode, install the following themes in vscode:


* Dark Green Jungle Theme
* Onedark
* Catppuccin
* Everforest Pro
* Gruvbox Theme
* Monochrome
* Nord
* Rose Pine


### B. Hypr folder (main hyprland folder):

#### 1. Modules:

All the functionality of hyprland has been split into amny modules placed inside of hypr/module/ folder which are sourced to hyprland.lua file.


#### 2. Switchers:

This folder contains the bash script for all the custom switchers like custom theme switcher, custom Wallpaper switcher, custom wallpaper transition switcher, custom waybar switcher


#### 3. Wallpapers: 

This folder contains all the wallpapers sorted by catgeory wise which is necessary for the wallpaper switcher to identify when to use which wallpaper set.


## 2. All package folders:

This includes all folders like kitty, rofi, swaync, waybar.

Basically these folders contains config and color files of each of the package respectively.

If you want to add your own custom theme or color then do not make any changes inside of these folders, just do changes inside of the theme folder as i have instructed below:

## 3. Theme folder:

All the custom themeing happens here 
You can add your own theme folder and then copy the format of any other theme inside of the theme folder 
like having all the directories hypr, waybar, kitty, rofi, hyprlock, and all the files like current-theme.txt and wallpaper.png

basically what you will do is look at my previously made theme color files and you will paste that inside of any LLM and ask it to make a color pallette like what i have made of any theme you would like
and then paste those files with appropriate file name inside their designated folders 

and vallahh your custom theme is added to custom theme swithcer

##4. Installer

this is the installer, I'm still improving it but it should work for now, I'll make more changes and improvements.




