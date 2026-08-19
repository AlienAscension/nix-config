-- Hyprland Lua config for v0.55.4 (API 550.0.0).
-- Appended by Home Manager after the generated systemd startup hook.

-- Monitors: laptop panel (eDP-1) if present, plus external monitor.
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "",      mode = "2560x1440@180", position = "auto", scale = "auto" })

-- Look & feel
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        layout = "dwindle",
    },
    decoration = {           -- NOTE: singular "decoration", not "decorations"
        rounding = 10,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
    },
    animations = {
        enabled = true,
    },
})

-- Input
hl.config({
    input = {
        kb_layout = "us,de",
        kb_variant = ",",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Keybinds
local mainMod = "SUPER"

-- Launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + Y",      hl.dsp.exec_cmd("ghostty -e yazi"))

-- Window management
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",      hl.dsp.window.fullscreen())
hl.bind("F11",                  hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M",      hl.dsp.exit())

-- Focus movement (arrows + vim keys)
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))

-- Swap windows (vim keys)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- Workspaces (SUPER+1-0 to switch, SUPER+SHIFT+1-0 to move window)
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,      hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",      hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse: drag with LMB, resize with RMB
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
