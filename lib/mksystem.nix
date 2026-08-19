# Build a NixOS system for a named machine with a per-machine architecture.
# Mirrors the structure of mitchellh/nixos-config's lib/mksystem.nix but
# stripped down: no darwin, no WSL, no overlays plumbing.
{ nixpkgs, inputs }:

name:
{ system, user ? "linus" }:

let
  sharedModules = [
    ../modules/system/default.nix
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [ inputs.noctalia.homeModules.default ];
    }
  ];
in
nixpkgs.lib.nixosSystem {
  inherit system;
  modules = sharedModules ++ [
    ../machines/${name}/configuration.nix
    ../machines/${name}/hardware.nix
    ../machines/${name}/secrets.nix
  ];
  specialArgs = { inherit inputs; };
}
