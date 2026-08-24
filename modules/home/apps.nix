{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    signal-desktop
    keepassxc
    spotify
    libreoffice
  ];

  programs.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
      };
    };
  };
}