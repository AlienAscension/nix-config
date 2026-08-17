{ pkgs, inputs, ... }:

{
  # Allow unfree packages (e.g. discord)
  nixpkgs.config.allowUnfree = true;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:Gpu9DBjrIDJMWCR1ZEn6uG8m9f9RLfK7tt7D1E8S78="
    ];
  };

  # Weekly garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 22 ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Users
  users.users.linus = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "network" "podman" ];
    shell = pkgs.zsh;
  };

  # Work user option — disabled by default, enabled per-machine
  # When work laptop arrives, the machine config will set:
  #   users.users.work = { isNormalUser = true; ... };

  # Locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Keyboard
  console.keyMap = "us";
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  # Base system packages
  environment.systemPackages = with pkgs; [
    btrfs-progs
    smartmontools
    usbutils
    pciutils
    nh
  ];

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # XDG Portals (screen sharing, file dialogs)
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  # Zsh as default shell for all users
  programs.zsh.enable = true;
}