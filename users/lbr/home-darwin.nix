{ ... }:

{
  imports = [
    ../../modules/home/cli.nix
    ../../modules/home/editor.nix
    ../../modules/home/terminal.nix
    ../../modules/home/dev.nix
    ../../modules/home/darwin.nix
  ];

  home.username = "lbr";
  home.homeDirectory = "/Users/lbr";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings.user.name = "AlienAscension";
    # Email is set manually after install (private): git config --global user.email <email>
  };
}
