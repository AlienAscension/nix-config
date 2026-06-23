{ pkgs, ... }:

{
  home.packages = with pkgs; [
    librewolf
    discord
    signal-desktop
    keepassxc
    spotify
    logseq
    libreoffice
    flameshot
  ];
}