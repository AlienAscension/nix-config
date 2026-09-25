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

  # AeroSpace's launchd environment has a minimal PATH, so its callbacks call
  # SketchyBar via the store path directly.
  sketchybarBin = "${pkgs.sketchybar}/bin/sketchybar";
in
{
  # AeroSpace tiling window manager — replaces Hyprland on macOS.
  programs.aerospace = {
    enable = true;
    launchd.enable = true;

    settings = {
      # Notify SketchyBar about the focused workspace (see modules/home/sketchybar).
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${sketchybarBin} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 300;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;

      # Leave room for the top SketchyBar (height 36 + padding).
      gaps = {
        inner.horizontal = 8;
        inner.vertical = 8;
        outer.left = 10;
        outer.right = 10;
        outer.bottom = 10;
        outer.top = 46;
      };

      # Float common dialog-like apps.
      on-window-detected = [
        { "if".app-name-regex-substring = "finder"; run = "layout floating"; }
        { "if".app-name-regex-substring = "settings"; run = "layout floating"; }
        { "if".app-name-regex-substring = "1password"; run = "layout floating"; }
        { "if".app-name-regex-substring = "quicktime"; run = "layout floating"; }
      ];

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
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];
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

  # Top bar (Catppuccin Mocha). Structure inspired by
  # https://github.com/omerxx/dotfiles, with the bar moved from the right edge
  # to the top. Sources live in modules/home/sketchybar/.
  programs.sketchybar = {
    enable = true;
    config = {
      source = ./sketchybar;
      recursive = true;
    };
    # `aerospace` is used by items/spaces.sh to enumerate workspaces.
    extraPackages = [ pkgs.aerospace ];
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
