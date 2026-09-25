{ pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    # nixpkgs' ghostty is Linux-only; on macOS the app is installed via the
    # Homebrew cask, so don't pull the (unsupported) package into home.packages.
    package = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);
    settings = {
      theme = "Catppuccin Frappe";
      mouse-hide-while-typing = true;
      confirm-close-surface = false;

      background-opacity = 0.85;

      font-size = 14;
    }
    # On Linux, drop client-side decorations entirely.
    // lib.optionalAttrs pkgs.stdenv.isLinux { window-decoration = false; }
    # On macOS, `window-decoration = false` makes the window borderless, which
    # macOS treats as fullscreen and auto-hides the menu bar. Hiding just the
    # titlebar keeps the native borders and the menu bar visible.
    // lib.optionalAttrs pkgs.stdenv.isDarwin { macos-titlebar-style = "hidden"; };
  };
}