-- ---- WINDOWRULES ----

-- Example windowrules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events", 
    match = { class = ".*" },          
    suppress_event = "maximize",       
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags", 
    match = {
        class      = "^$",       
        title      = "^$",       
        xwayland   = true,       
        float      = true,       
        fullscreen = false,      
        pin        = false,     
    },
    no_focus = true,             
})

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run", 
    match = { class = "hyprland-run" }, 
    move = "20 monitor_h-120",  
    float = true,               
})

-- Layer Rules for swaync-control-center
hl.layer_rule({
    match = { namespace = "swaync-control-center" }, 
    blur = true,            
    ignore_alpha = 0.5,     
})

-- Layer Rules for swaync-notification-window
hl.layer_rule({
    match = { namespace = "swaync-notification-window" }, 
    blur = true,            
    ignore_alpha = 0.5,     
})