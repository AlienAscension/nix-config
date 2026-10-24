{ pkgs, lib, ... }:

let
  # Tiling "leader". On macOS, bare Command is the primary *application*
  # modifier, so binding cmd-v / cmd-s / cmd-f / cmd-q / cmd-1..9 shadows
  # Paste / Save / Find / Quit and app tab switching. Instead, Caps Lock is
  # remapped by Karabiner to Cmd+Ctrl+Option ("Hyper" minus Shift — see the
  # Karabiner rule below). Shift is deliberately left out so that
  # leader+shift+... still works for the move-window bindings.
  mainMod = "cmd-ctrl-alt";

  # The ghostty cask ships no `ghostty` CLI symlink and AeroSpace's launchd
  # environment has a minimal PATH, so exec bindings need absolute paths.
  yazi = "${pkgs.yazi}/bin/yazi";

  # Executing the ghostty binary directly starts a separate app instance (its
  # own Dock icon) every time. Instead, ask the running instance for a new
  # window via AppleScript, and only launch the app when it isn't running.
  # Errors go to ~/Library/Logs/ghostty-window.log (AeroSpace discards them).
  ghosttyWindowScript = pkgs.writeShellScript "ghostty-window" ''
    exec 2>>"$HOME/Library/Logs/ghostty-window.log"
    echo "$(date) ghostty-window $*" >&2
    if [ "$(/usr/bin/osascript -e 'application "Ghostty" is running')" = true ]; then
      /usr/bin/osascript - "$@" <<'EOF'
    on run argv
      tell application "Ghostty"
        set cfg to new surface configuration
        if (count of argv) > 0 then set command of cfg to item 1 of argv
        new window with configuration cfg
      end tell
    end run
    EOF
    elif [ $# -gt 0 ]; then
      /usr/bin/open -a Ghostty --args -e "$1"
    else
      /usr/bin/open -a Ghostty
    fi
  '';
  ghosttyWindow = cmd: "exec-and-forget ${ghosttyWindowScript}${lib.optionalString (cmd != null) " ${cmd}"}";
  workspaces = lib.range 1 10;
in
{
  # AeroSpace tiling window manager — replaces Hyprland on macOS.
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 300;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;

      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 10;
        outer.right = 10;
        outer.bottom = 10;
        outer.top = 10;
      };

      # Float common dialog-like apps.
      on-window-detected = map (app: { "if".app-name-regex-substring = app; run = "layout floating"; }) [
        "finder"
        "settings"
        "1password"
        "quicktime"
      ];

      mode.main.binding = {
        # Launchers
        "${mainMod}-enter" = ghosttyWindow null;
        # AeroSpace binds by US-QWERTY key position: "z" is the key labeled Y on
        # the German MacBook keyboard (bottom left, one-hand reachable).
        "${mainMod}-z" = ghosttyWindow yazi;
        # TODO: choose a launcher replacement for `noctalia msg panel-toggle launcher`
        # (Raycast/Alfred/Spotlight) and bind it here.
        # "${mainMod}-d" = "exec-and-forget ...";
        # TODO: lock session replacement for `noctalia msg session lock`.
        # "${mainMod}-l" = "exec-and-forget ...";

        # Window management
        # Closing an app's last window doesn't quit it on macOS (Dock dot stays).
        "${mainMod}-q" = "close --quit-if-last-window";
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

        # Join with neighbour (arrows)
        "${mainMod}-shift-left" = "join-with left";
        "${mainMod}-shift-right" = "join-with right";
        "${mainMod}-shift-up" = "join-with up";
        "${mainMod}-shift-down" = "join-with down";

        # Resize
        "${mainMod}-shift-minus" = "resize smart -50";
        "${mainMod}-shift-equal" = "resize smart +50";

        # Layout cycling
        "${mainMod}-slash" = "layout tiles horizontal vertical";
        "${mainMod}-comma" = "layout accordion horizontal vertical";

        # Scratchpad / previous workspace
        "${mainMod}-s" = [ "workspace-back-and-forth" ]; # Approximation of special workspace toggle
        "${mainMod}-shift-s" = "move-node-to-workspace S";
        "${mainMod}-tab" = "workspace-back-and-forth";
        "${mainMod}-shift-tab" = "move-workspace-to-monitor --wrap-around next";

        # Service mode (esc: reload, r: flatten, f: float, backspace: close others)
        "${mainMod}-shift-semicolon" = "mode service";
      } // lib.mergeAttrsList (map (i:
        let
          ws = toString i;
          key = toString (lib.mod i 10);
        in {
          "${mainMod}-${key}" = "workspace ${ws}";
          "${mainMod}-shift-${key}" = [ "move-node-to-workspace ${ws}" "workspace ${ws}" ];
        }
      ) workspaces);

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];
      };

      # The external LG is the primary work display: route every workspace
      # there. Fall back to 'main' when the LG isn't connected (undocked) so
      # workspaces still land on the built-in display. The scratchpad "S" is
      # unassigned, so it defaults to the macOS main display (the MacBook).
      # NOTE: AeroSpace doesn't support i3-style "switch on the focused
      # monitor"; a workspace always appears on its assigned monitor.
      workspace-to-monitor-force-assignment =
        lib.genAttrs (map toString workspaces) (_: [ "LG" "main" ]);
    };
  };

  # macOS-native pinentry for GPG Agent
  services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

  # Python package/project manager. Installed via nix so it survives reboots:
  # the upstream curl installer appends PATH updates to ~/.zshrc, which is a
  # read-only home-manager symlink here ("Permission denied").
  #
  # docker + colima: the Linux machines get a `docker` CLI for free from
  # virtualisation.podman's dockerCompat (modules/system/default.nix), but
  # macOS has no kernel to run containers natively. colima supplies the Linux
  # VM; `colima start` boots it, then the docker CLI talks to it over the
  # socket colima configures. No GUI — this is deliberately lighter than
  # Docker Desktop.
  home.packages = [ pkgs.uv pkgs.docker pkgs.colima pkgs.lima ];

  # Karabiner rules managed here:
  #   1. Option+Shift switches input source. macOS cannot bind a bare-modifier
  #      combo to input-source switching, so Karabiner does it. We use
  #      `select_input_source` rather than synthesising the Control+Space
  #      shortcut, because it is unaffected by the physical modifiers still
  #      being held while `to_if_alone` fires, and the lazy passthrough keeps
  #      Option+Shift+<key> working for text selection.
  #   2. Caps Lock is the AeroSpace "Hyper" leader (tap = Escape).
  #
  # Karabiner's own config is managed here so the rules are always active; don't
  # edit it from the Karabiner GUI or home-manager will revert it on next switch.
  xdg.configFile."karabiner/karabiner.json" = {
    # `force` because Karabiner rewrites its config as a regular file on launch;
    # without it home-manager tries to back the file up on every switch and
    # fails once a .backup already exists.
    force = true;
    text = builtins.toJSON {
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
          {
            # Caps Lock is the AeroSpace leader ("Hyper" without Shift), so it
            # works on every keyboard. Karabiner adds Ctrl+Option on top of
            # Command, so holding it and pressing a key sends Cmd+Ctrl+Opt+<key>.
            # Physical Shift is untouched, leaving leader+shift+... free for the
            # move bindings. A quick tap still emits Escape.
            description = "Caps Lock: tap = Escape, hold = Hyper (Cmd+Ctrl+Opt)";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers = { optional = [ "any" ]; };
                };
                to = [
                  {
                    key_code = "right_command";
                    modifiers = [ "left_control" "left_option" ];
                    lazy = true;
                  }
                ];
                to_if_alone = [ { key_code = "escape"; } ];
                to_if_held_down = [
                  {
                    key_code = "right_command";
                    modifiers = [ "left_control" "left_option" ];
                  }
                ];
                parameters = {
                  "basic.to_if_alone_timeout_milliseconds" = 200;
                  "basic.to_if_held_down_threshold_milliseconds" = 200;
                };
              }
            ];
          }
        ];
      }
    ];
    };
  };

  # Also enable the native Control+Space toggle as a manual fallback. It ships
  # disabled on macOS.
  home.activation.enableInputSourceShortcut = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
      '{ enabled = 1; value = { type = standard; parameters = (32, 49, 262144); }; }'
    /usr/bin/killall cfprefsd 2>/dev/null || true
  '';
}
