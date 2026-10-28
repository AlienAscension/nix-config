{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    chiaki
    firefox
    gnome-calculator
    signal-desktop
    keepassxc
    libreoffice
    flameshot
    kdePackages.okular
  ] ++ lib.optionals pkgs.stdenv.isx86_64 [
    # Spotify is not packaged for aarch64-linux in this nixpkgs pin.
    # Steam is enabled system-wide via `programs.steam.enable` on x86_64 hosts.
    spotify
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
