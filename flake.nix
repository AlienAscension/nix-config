{
  description = "NixOS configuration with Hyprland for desktop and laptop";

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

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland, agenix, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      sharedModules = [
        ./modules/system/default.nix
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
      ];
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = sharedModules ++ [
          ./machines/desktop/configuration.nix
          ./machines/desktop/hardware.nix
          ./machines/desktop/secrets.nix
        ];
        specialArgs = { inherit inputs; };
      };

      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = sharedModules ++ [
          ./machines/laptop/configuration.nix
          ./machines/laptop/hardware.nix
          ./machines/laptop/secrets.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
}