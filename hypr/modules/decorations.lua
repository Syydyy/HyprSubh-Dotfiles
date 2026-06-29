-- ---- LOOK AND FEEL (DECORATIONS) ----

-- Refer to https://wiki.hypr.land/Configuring/Variables/

-- Import the colors table (Ensure this path matches where you save colors.lua)
local colors = require("modules/colors") 

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,

        border_size = 1,

        col = {
            active_border = colors.active_border,
            inactive_border = colors.inactive_border,
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = true,

        layout = "dwindle",
    },

    -- https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
        rounding = 10,
        rounding_power = 10,

        -- Change transparency of focused and unfocused windows
        active_opacity = 0.9,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 10,
            render_power = 4,
            color = "rgba(0a0a0add)",
        },

        -- https://wiki.hypr.land/Configuring/Variables/#blur
        blur = {
            enabled = true,
            size = 7,
            passes = 3,
            ignore_opacity = true,

            noise = 0.02,
            contrast = 1.5,
            vibrancy = 0.2,

            xray = false,
            new_optimizations = true,
        }
    }
})