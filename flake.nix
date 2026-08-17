{
  description = "NixOS configuration with Hyprland for desktop, laptop, geekom, and aarch64 VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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
  };

  outputs = inputs @ { nixpkgs, home-manager, hyprland, agenix, ... }:
    let
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
    in
    {
      nixosConfigurations.desktop = mkSystem "desktop" { system = "x86_64-linux"; };
      nixosConfigurations.laptop = mkSystem "laptop" { system = "x86_64-linux"; };
      nixosConfigurations.geekom = mkSystem "geekom" { system = "x86_64-linux"; };
    };
}
