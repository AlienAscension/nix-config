# Build a nix-darwin system for a named machine with a per-machine architecture.
# Mirrors lib/mksystem.nix but for macOS: uses nix-darwin's darwinSystem,
# agenix/home-manager/nix-homebrew darwin modules, imports the machine's
# configuration.nix and secrets.nix, and wires the per-user home-manager entrypoint.
{ nixpkgs, inputs }:

name:
{ system, user ? "linus" }:

let
  sharedModules = [
    inputs.agenix.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      networking.hostName = name;

      environment.systemPackages = [
        inputs.agenix.packages.${system}.default
      ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-darwin.nix;
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
