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
        kb_variant = ",T1",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Keybinds
local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + Y",      hl.dsp.exec_cmd("ghostty -e yazi"))
hl.bind(mainMod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind("F11",                  hl.dsp.window.fullscreen())
