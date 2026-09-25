# Build a nix-darwin system for a named machine with a per-machine architecture.
# Mirrors lib/mksystem.nix but for macOS: uses nix-darwin's darwinSystem,
# agenix/home-manager/nix-homebrew darwin modules, and imports the machine's
# configuration.nix (which itself wires in the per-user home-manager entrypoint).
{ nixpkgs, inputs }:

name:
{ system, user ? "linus" }:

let
  sharedModules = [
    inputs.agenix.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      environment.systemPackages = [
        inputs.agenix.packages.${system}.default
      ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    }
  ];
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  modules = sharedModules ++ [
    ../machines/${name}/configuration.nix
    ../machines/${name}/secrets.nix
  ];
  specialArgs = { inherit inputs; };
}
