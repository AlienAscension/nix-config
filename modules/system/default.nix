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
    substituters = [
      "https://hyprland.cachix.org"
      "https://noctalia.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
    openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDVVBEczaQJD335qqxJIy8Su2/s4d1p93XOSUfr64eIzPPOyQmkqOzLxnm5LZxinahUOfHUsIcnqygJsc2oGDmqQzU0miiHdao8Pg/u0qYoPkaiinupTqopr+cTr7fj+/TGqFSM/fJSBWzpDIMsU5+Fc1yGWbTy2HdT/LaPMXo9DPEbFgboclkdGbXPf45uR+Nqz+86iSlgv2+jTZZknXupYI5aBNAOpOtyZzYtVcDR7jLA4Kqkmo2qkjHa7hpPVozdkSWQdVg7aWOVgFo+FDEl+iSpHpryiqG13Z2uNIdAVntaNBcBUJy2nTPk8Sfa94j72pW7a2VuNlUiE2mJP8TKwsSrkUXhmJ7jchPboOniRiI82qGdd2OT9d6T3heYEu0zSWqJZyqawO+NKxHdukZl8ABicKrkYPF/lE6OcsJid/HXVbgHDTqjQ2GnDixxfj6HACqW28f8sWfFvko44kUj89lRKyF6OVpEqHkVQrPXyriKE/hELKLY1etBguL3L2s3F5/r2G9HFqKO2PRcpNSFqi/Ll8m9ZAoxeL3llWNsmkjXj5Xi7TeES5Q4J+mAgSoAARFwPGHmAx8UcT9CQDskGKgTeT34/FOa7SAYU8BYN0Tf6i3GSqwPLLtLqraQkDZaEiP5zhj5L4nQks3vkgBJU7OaqFawZHrtHyGc9askVQ== linus.breitenberger@gmail.com"
  ];
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

  # Display manager (SDDM, for Hyprland session)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Zsh as default shell for all users
  programs.zsh.enable = true;
}