{ pkgs, lib, ... }:

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

  # nodejs/npx — macbook-only, not shared via modules/home/dev.nix.
  home.packages = [ pkgs.nodejs ];

  programs.git = {
    enable = true;
    settings.user.name = lib.mkForce "Linus Breitenberger";
    settings.user.email = lib.mkForce "linus.breitenberger@inovex.de";
  };
}
