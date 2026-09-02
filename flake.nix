{
  description = "NixOS configuration with Hyprland for desktop, laptop, geekom, and aarch64 VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Extra channel used only to cherry-pick newer packages via overlay
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia desktop shell — pinned to the `cachix` branch (latest CI-cached commit).
    # NOTE: deliberately NO `inputs.nixpkgs.follows` here — following nixpkgs changes the
    # derivation hash and disables the noctalia binary cache. See modules/system/default.nix.
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    # Noctalia Greeter (greetd greeter) — no documented binary cache, so follows nixpkgs.
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, hyprland, agenix, ... }:
    let
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
    in
    {
      nixosConfigurations.desktop = mkSystem "desktop" { system = "x86_64-linux"; };
      nixosConfigurations.laptop = mkSystem "laptop" { system = "x86_64-linux"; };
      nixosConfigurations.geekom = mkSystem "geekom" { system = "x86_64-linux"; };
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" { system = "aarch64-linux"; };
    };
}
