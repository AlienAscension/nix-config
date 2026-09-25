{ ... }:

{
  imports = [
    ../../modules/system/darwin.nix
    ./secrets.nix
  ];

  networking.hostName = "macbook";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "lbr";

  # This Mac runs Determinate Nix, which manages the Nix installation, the
  # nix-daemon, and /etc/nix/nix.conf itself. nix-darwin must not manage them
  # too, or activation aborts with "Determinate detected, aborting activation".
  # Flakes are already enabled by Determinate, so no nix.settings are needed.
  nix.enable = false;

  # Homebrew management via nix-homebrew.
  # autoMigrate lets nix-homebrew take over the pre-existing /opt/homebrew
  # installation (it deletes the old Homebrew checkout and re-creates it under
  # nix management). Without it, activation aborts with
  # "An existing /opt/homebrew/Library/Homebrew is in the way".
  nix-homebrew = {
    enable = true;
    user = "lbr";
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      # Terminal used by the AeroSpace launcher binds (ghostty is not in the
      # pinned nixpkgs for aarch64-darwin, so install via Homebrew).
      "ghostty"
    ];
  };

  users.users.lbr = {
    home = "/Users/lbr";
  };

  # Home Manager
  home-manager.users.lbr = import ../../users/lbr/home-darwin.nix;

  # Move pre-existing dotfiles aside (e.g. a hand-written ~/.ssh/config)
  # instead of aborting activation with "Existing file ... would be clobbered".
  home-manager.backupFileExtension = "backup";

  system.stateVersion = 6;
}
