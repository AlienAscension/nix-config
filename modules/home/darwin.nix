{ pkgs, lib, ... }:

let
  # Tiling modifier. On macOS, bare Command is the primary *application*
  # modifier, so binding cmd-v / cmd-s / cmd-f / cmd-q / cmd-1..9 shadows
  # Paste / Save / Find / Quit and app tab switching. Control+Option is
  # essentially unused by apps, so use that instead (the Hyprland "SUPER").
  mainMod = "ctrl-alt";

  # The ghostty cask ships no `ghostty` CLI symlink and AeroSpace's launchd
  # environment has a minimal PATH, so exec bindings need absolute paths.
  ghostty = "/Applications/Ghostty.app/Contents/MacOS/ghostty";
  yazi = "/etc/profiles/per-user/lbr/bin/yazi";
in
{
  # AeroSpace tiling window manager — replaces Hyprland on macOS.
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      # Match the general feel of the Hyprland config
      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          left = 10;
          bottom = 10;
          top = 10;
          right = 10;
        };
      };

      mode.main.binding = {
        # Launchers
        "${mainMod}-enter" = "exec-and-forget ${ghostty}";
        "${mainMod}-y" = "exec-and-forget ${ghostty} -e ${yazi}";
        # TODO: choose a launcher replacement for `noctalia msg panel-toggle launcher`
        # (Raycast/Alfred/Spotlight) and bind it here.
        # "${mainMod}-d" = "exec-and-forget ...";
        # TODO: lock session replacement for `noctalia msg session lock`.
        # "${mainMod}-l" = "exec-and-forget ...";

        # Window management
        "${mainMod}-q" = "close";
        "${mainMod}-v" = "layout floating tiling";
        "${mainMod}-f" = "fullscreen";
        "f11" = "fullscreen";

        # Focus movement (arrows + vim keys)
        "${mainMod}-left" = "focus left";
        "${mainMod}-right" = "focus right";
        "${mainMod}-up" = "focus up";
        "${mainMod}-down" = "focus down";
        "${mainMod}-h" = "focus left";
        "${mainMod}-j" = "focus down";
        "${mainMod}-k" = "focus up";
        "${mainMod}-l" = "focus right";

        # Swap windows (vim keys)
        "${mainMod}-shift-h" = "move left";
        "${mainMod}-shift-j" = "move down";
        "${mainMod}-shift-k" = "move up";
        "${mainMod}-shift-l" = "move right";

        # Workspaces (cmd+1-0 to switch, cmd+shift+1-0 to move window)
        "${mainMod}-1" = "workspace 1";
        "${mainMod}-2" = "workspace 2";
        "${mainMod}-3" = "workspace 3";
        "${mainMod}-4" = "workspace 4";
        "${mainMod}-5" = "workspace 5";
        "${mainMod}-6" = "workspace 6";
        "${mainMod}-7" = "workspace 7";
        "${mainMod}-8" = "workspace 8";
        "${mainMod}-9" = "workspace 9";
        "${mainMod}-0" = "workspace 10";

        "${mainMod}-shift-1" = [ "move-node-to-workspace 1" "workspace 1" ];
        "${mainMod}-shift-2" = [ "move-node-to-workspace 2" "workspace 2" ];
        "${mainMod}-shift-3" = [ "move-node-to-workspace 3" "workspace 3" ];
        "${mainMod}-shift-4" = [ "move-node-to-workspace 4" "workspace 4" ];
        "${mainMod}-shift-5" = [ "move-node-to-workspace 5" "workspace 5" ];
        "${mainMod}-shift-6" = [ "move-node-to-workspace 6" "workspace 6" ];
        "${mainMod}-shift-7" = [ "move-node-to-workspace 7" "workspace 7" ];
        "${mainMod}-shift-8" = [ "move-node-to-workspace 8" "workspace 8" ];
        "${mainMod}-shift-9" = [ "move-node-to-workspace 9" "workspace 9" ];
        "${mainMod}-shift-0" = [ "move-node-to-workspace 10" "workspace 10" ];

        # Scratchpad
        "${mainMod}-s" = [ "workspace-back-and-forth" ]; # Approximation of special workspace toggle
        "${mainMod}-shift-s" = "move-node-to-workspace S";
      };

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "secondary";
        "6" = "main";
        "7" = "main";
        "8" = "main";
        "9" = "main";
        "10" = "main";
      };
    };
  };

  # Menu bar replacement — minimal default config; theming is a follow-up task.
  programs.sketchybar = {
    enable = true;
    config = ''
      sketchybar --bar height=32 position=top padding_left=10 padding_right=10
      sketchybar --default icon.font="SF Pro:Bold:14.0" label.font="SF Pro:Bold:14.0"
      sketchybar --add item clock right --set clock script="date '+%H:%M'" update_freq=10
      sketchybar --update
    '';
  };

  # macOS-native pinentry for GPG Agent
  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  # macOS cannot bind a bare-modifier combo (e.g. Option+Shift) to input-source
  # switching, so Karabiner does it. We use `select_input_source` rather than
  # synthesising the Control+Space shortcut, because it is unaffected by the
  # physical modifiers still being held while `to_if_alone` fires, and the lazy
  # passthrough keeps Option+Shift+<key> working for text selection.
  #
  # Karabiner's own config is managed here so the rule is always active; don't
  # edit it from the Karabiner GUI or home-manager will revert it on next switch.
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
    profiles = [
      {
        name = "Default profile";
        selected = true;
        complex_modifications.rules = [
          {
            description = "Option+Shift switches input source (DE <-> EurKEY)";
            manipulators =
              let
                eurkey = "^de\\.felixfoertsch\\.keyboardlayout\\.EurKEY-Next\\.eurkeynext$";
                german = "^com\\.apple\\.keylayout\\.German$";
                combos = [
                  { trigger = "left_shift"; held = "left_option"; }
                  { trigger = "left_option"; held = "left_shift"; }
                  { trigger = "right_shift"; held = "right_option"; }
                  { trigger = "right_option"; held = "right_shift"; }
                ];
                mk = { trigger, held }: current: target: {
                  type = "basic";
                  from = {
                    key_code = trigger;
                    modifiers = { mandatory = [ held ]; };
                  };
                  to = [ { key_code = trigger; modifiers = [ held ]; lazy = true; } ];
                  to_if_alone = [ { select_input_source = { input_source_id = target; }; } ];
                  conditions = [
                    { type = "input_source_if"; input_sources = [ { input_source_id = current; } ]; }
                  ];
                };
              in
              builtins.concatMap (c: [ (mk c eurkey german) (mk c german eurkey) ]) combos;
          }
        ];
      }
    ];
  };

  # Also enable the native Control+Space toggle as a manual fallback. It ships
  # disabled on macOS.
  home.activation.enableInputSourceShortcut = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
      '{ enabled = 1; value = { type = standard; parameters = (32, 49, 262144); }; }'
    /usr/bin/killall cfprefsd 2>/dev/null || true
  '';
}
