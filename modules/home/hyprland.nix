{ pkgs, ... }:

{
  # Hyprland compositor only. The desktop shell (bar, launcher, lock screen,
  # wallpaper, idle) is provided by noctalia — see modules/home/noctalia.nix.
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;       # installed by the NixOS module (flake v0.55.4)
    portalPackage = null; # portal wired up by the NixOS module
    settings = { };       # avoid HM's broken hl.* Lua generation
    extraConfig = builtins.readFile ./hyprland.lua;
  };

  home.packages = with pkgs; [
    brightnessctl
  ];
}
