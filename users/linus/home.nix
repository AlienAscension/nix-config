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

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    userName = "linus";
    userEmail = "linus@example.com";  # Replace with real email
  };

  # p10k config — symlink the existing ~/.p10k.zsh if present, otherwise
  # the user runs `p10k configure` after first boot
  home.file.".p10k.zsh".text = "";  # Placeholder; user will run p10k configure
}