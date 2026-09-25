{ pkgs, ... }:

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
        "cmd-enter" = "exec-and-forget ghostty";
        "cmd-y" = "exec-and-forget ghostty -e yazi";
        # TODO: choose a launcher replacement for `noctalia msg panel-toggle launcher`
        # (Raycast/Alfred/Spotlight) and bind it here.
        # "cmd-d" = "exec-and-forget ...";
        # TODO: lock session replacement for `noctalia msg session lock`.
        # "cmd-alt-l" = "exec-and-forget ...";

        # Window management
        "cmd-q" = "close";
        "cmd-v" = "layout floating tiling";
        "cmd-f" = "fullscreen";
        "f11" = "fullscreen";

        # Focus movement (arrows + vim keys)
        "cmd-left" = "focus left";
        "cmd-right" = "focus right";
        "cmd-up" = "focus up";
        "cmd-down" = "focus down";
        "cmd-h" = "focus left";
        "cmd-j" = "focus down";
        "cmd-k" = "focus up";
        "cmd-l" = "focus right";

        # Swap windows (vim keys)
        "cmd-shift-h" = "move left";
        "cmd-shift-j" = "move down";
        "cmd-shift-k" = "move up";
        "cmd-shift-l" = "move right";

        # Workspaces (cmd+1-0 to switch, cmd+shift+1-0 to move window)
        "cmd-1" = "workspace 1";
        "cmd-2" = "workspace 2";
        "cmd-3" = "workspace 3";
        "cmd-4" = "workspace 4";
        "cmd-5" = "workspace 5";
        "cmd-6" = "workspace 6";
        "cmd-7" = "workspace 7";
        "cmd-8" = "workspace 8";
        "cmd-9" = "workspace 9";
        "cmd-0" = "workspace 10";

        "cmd-shift-1" = [ "move-node-to-workspace 1" "workspace 1" ];
        "cmd-shift-2" = [ "move-node-to-workspace 2" "workspace 2" ];
        "cmd-shift-3" = [ "move-node-to-workspace 3" "workspace 3" ];
        "cmd-shift-4" = [ "move-node-to-workspace 4" "workspace 4" ];
        "cmd-shift-5" = [ "move-node-to-workspace 5" "workspace 5" ];
        "cmd-shift-6" = [ "move-node-to-workspace 6" "workspace 6" ];
        "cmd-shift-7" = [ "move-node-to-workspace 7" "workspace 7" ];
        "cmd-shift-8" = [ "move-node-to-workspace 8" "workspace 8" ];
        "cmd-shift-9" = [ "move-node-to-workspace 9" "workspace 9" ];
        "cmd-shift-0" = [ "move-node-to-workspace 10" "workspace 10" ];

        # Scratchpad
        "cmd-s" = [ "workspace-back-and-forth" ]; # Approximation of special workspace toggle
        "cmd-shift-s" = "move-node-to-workspace S";
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
}
