{ pkgs, ... }:

{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/editor.nix
    ../../modules/home/terminal.nix
    ../../modules/home/dev.nix
    ../../modules/home/apps.nix
    ../../modules/home/hyprland.nix
  ];

  home.username = "work";
  home.homeDirectory = "/home/work";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    userName = "work";  # Replace with real work name
    userEmail = "work@example.com";  # Replace with real work email
  };
}