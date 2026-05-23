-- ---- Monitors ----

-- Default Monitor:
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@144",
    position = "0x0",
    scale    = "1.20",
})

-- Workspaces 1 to 5 (Persistent)
for i = 1, 5 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = "eDP-1",
        persistent = true,
    })
end

-- Workspaces 6 to 10 (Non-persistent)
for i = 6, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = "eDP-1",
    })
end