{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    chiaki
    firefox
    signal-desktop
    keepassxc
    libreoffice
    flameshot
    kdePackages.okular
  ] ++ lib.optionals pkgs.stdenv.isx86_64 [
    # Spotify and Steam are not packaged for aarch64-linux in this nixpkgs pin.
    spotify
    steam
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
