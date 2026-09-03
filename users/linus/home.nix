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

  home.sessionVariables = {
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
    HYPRCURSOR_SIZE = 30;
    XCURSOR_THEME = "rose-pine-hyprcursor";
    XCURSOR_SIZE = 30;
  };

  programs.git = {
    enable = true;
    settings.user.name = "AlienAscension";
    # Email is set manually after install (private): git config --global user.email <email>
  };

  # p10k prompt config — regenerate with `p10k configure` and copy the
  # result here (the wizard writes to a temp dir when ~/.p10k.zsh is
  # HM-managed)
  home.file.".p10k.zsh".source = ./p10k.zsh;
}
