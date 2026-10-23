{ pkgs, ... }:

{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/editor.nix
    ../../modules/home/terminal.nix
    ../../modules/home/dev.nix
    ../../modules/home/linux-desktop.nix
    ../../modules/home/hyprland.nix
    ../../modules/home/noctalia.nix
  ];

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = 30;
    XCURSOR_THEME = "rose-pine-hyprcursor";
    XCURSOR_SIZE = 30;
  };

  programs.git.settings.user = {
    name = "AlienAscension";
    email = "148532831+AlienAscension@users.noreply.github.com";
  };
}
