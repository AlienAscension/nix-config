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
    kdePackages.okular
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.kde.okular.desktop";
      "image/jpeg" = "firefox.desktop";
      "image/png" = "firefox.desktop";
    };
    associations.added = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/jpeg" = [ "firefox.desktop" ];
      "image/png" = [ "firefox.desktop" ];
    };
  };

  xdg.configFile."flameshot/flameshot.ini".text = ''
    [General]
    useGrimAdapter=true
  '';
}
