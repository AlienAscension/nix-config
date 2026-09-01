{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
