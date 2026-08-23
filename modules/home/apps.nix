{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    signal-desktop
    keepassxc
    spotify
    libreoffice
    flameshot
  ];
}