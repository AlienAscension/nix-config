{ pkgs, ... }:

{
  home.packages = with pkgs; [
    chiaki
    firefox
    signal-desktop
    keepassxc
    spotify
    libreoffice
    flameshot
    steam
  ];

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    useGrimAdapter=true
  '';
}
