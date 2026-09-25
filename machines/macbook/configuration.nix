{ ... }:

{
  imports = [
    ../../modules/system/darwin.nix
    ./secrets.nix
  ];

  networking.hostName = "macbook";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "lbr";

  nix.settings.experimental-features = "nix-command flakes";

  # Homebrew management via nix-homebrew
  nix-homebrew = {
    enable = true;
    user = "lbr";
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

  system.stateVersion = 6;
}
