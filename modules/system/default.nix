{ pkgs, inputs, ... }:

{
  # Allow unfree packages (e.g. discord)
  nixpkgs.config.allowUnfree = true;

  # Cherry-pick newer packages from nixpkgs-unstable (see flake.nix inputs)
  nixpkgs.overlays = [
    (final: prev: {
      opencode = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.opencode;
    })
  ];

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
    extraGroups = [ "wheel" "audio" "video" "network" "networkmanager" "podman" "storage" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHLlTpfzeRXhIiduiVO9xytIttfkFgSIc+A5y75neUyd"
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
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    (callPackage ../../pkgs/topf.nix {})
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

  # Display manager — noctalia-greeter (greetd). Replaces SDDM.
  # The module enables greetd and sets the session command automatically;
  # it also enables accounts-daemon for user avatars on the login screen.
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  programs.noctalia-greeter = {
    enable = true;
    settings = {
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 24;
        path = "${pkgs.bibata-cursors}/share/icons";
      };
      keyboard = {
        layout = "us";
        variant = "altgr-intl";
      };
      session.default = "hyprland";
    };
  };

  # UPower — required by noctalia's battery widget.
  services.upower.enable = true;

  # USB auto-mounting (udisks2)
  services.udisks2.enable = true;

  # Zsh as default shell for all users
  programs.zsh.enable = true;
}
