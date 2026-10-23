{ pkgs, ... }:

{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/editor.nix
    ../../modules/home/terminal.nix
    ../../modules/home/dev.nix
    ../../modules/home/linux-desktop.nix
    ../../modules/home/hyprland.nix
  ];

  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "26.05";

  programs.git.settings.user = {
    name = "work";  # Replace with real work name
    email = "work@example.com";  # Replace with real work email
  };
}