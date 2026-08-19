{ ... }:

{
  # Noctalia desktop shell — bar, dock, launcher, control center, notifications,
  # wallpaper, lock screen, idle, OSDs, tray. Runs on top of Hyprland.
  # The home-manager module itself is imported via home-manager.sharedModules
  # in lib/mksystem.nix (so it's available to all users).
  programs.noctalia = {
    enable = true;
    systemd.enable = true; # auto-start as a systemd user service with the graphical session

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/home/linus/Pictures/wallpaper.jpg";
      };
    };
  };
}
