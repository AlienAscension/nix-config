{ pkgs, ... }:

{
  home.packages = with pkgs; [
    librewolf
    signal-desktop
    keepassxc
    spotify
    libreoffice
    flameshot
  ];
}