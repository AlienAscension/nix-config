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

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    useGrimAdapter=true
  '';
}