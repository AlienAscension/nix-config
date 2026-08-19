{ pkgs, ... }:

{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/editor.nix
    ../../modules/home/terminal.nix
    ../../modules/home/dev.nix
    ../../modules/home/apps.nix
    ../../modules/home/hyprland.nix
    ../../modules/home/noctalia.nix
  ];

  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings.user.name = "AlienAscension";
    # Email is set manually after install (private): git config --global user.email <email>
  };

  # p10k config — symlink the existing ~/.p10k.zsh if present, otherwise
  # the user runs `p10k configure` after first boot
  home.file.".p10k.zsh".text = "";  # Placeholder; user will run p10k configure
}