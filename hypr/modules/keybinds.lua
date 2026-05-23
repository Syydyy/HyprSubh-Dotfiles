-- ---- KEYBINDS ----

require("modules.programs")

-- -- Mod Keys --
local mainMod = "SUPER"

-- Terminal Related
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

-- Kill Active Window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- App Launcher
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("~/.config/rofi/launchers/type-3/launcher.sh || pkill rofi"))

-- Appearance Menu ( Theme, wallpaper, wallpaper transition, waybars, fonts )
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/switchers/set-appearance.sh"))

-- Waybar Switcher
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/switchers/set-waybar.sh"))

-- Wallpaper Selector
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/switchers/set-wallpaper.sh"))

-- Wallpaper Transition Selector
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/switchers/set-wallpaper-transition.sh"))

-- Custom Theme Switcher
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("pkill rofi || ~/.config/hypr/switchers/set-theme.sh"))

-- Notification center
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))

-- Clipboard Menu
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 -p 'Clipboard' -theme ~/.config/rofi/launchers/type-2/style-1.rasi | cliphist decode | wl-copy"))

-- Browser
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- File Manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- Screen Recording Application
hl.bind(mainMod .. " + KP_Insert", hl.dsp.exec_cmd("obs"))

-- Code Editor
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(codeEditor))

-- Toggle layout of windows
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- Toggles window layout
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

-- Hyperlock
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Logout of hyprland while closing all the applications
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("hyprctl eval 'hl.dispatch(hl.dsp.exit())'"))

-- Power Options through Rofi
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.config/rofi/powermenu/type-1/powermenu.sh"))

-- Move focus of windows with arrow keys and vim keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "l" }))

hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "r" }))

hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "u" }))

hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "d" }))

-- Swap Windows
hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.swap({ direction = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "r" }))
hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.swap({ direction = "u" }))
hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.swap({ direction = "d" }))
-- Maximize windows
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = 1 }))

-- Fullscreen windows
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 0 }))

-- Screenshot Keybinds
hl.bind("Print",                           hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + Print",             hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + SHIFT + Print",     hl.dsp.exec_cmd("hyprshot -m output -m eDP-1"))

-- Toggle Waybar ON/OFF
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd("~/.config/waybar/scripts/launch.sh"))

-- Toggle HyperPaper ON/OFF
hl.bind(mainMod .. " + CTRL + H", hl.dsp.exec_cmd("pkill " .. wallpaperEngine .. " || " .. wallpaperEngine))

-- Switching Workspaces & Moving Active Windows to Workspaces
for i = 1, 10 do
    local key = i % 10 -- Maps workspace 10 to the 0 key
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Toggle special Workspace (Scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume 5"),      { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"),     { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("swayosd-client --brightness +10"),       { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("swayosd-client --brightness -10"),       { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })