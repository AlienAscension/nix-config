{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/system/default.nix
    ./hardware.nix
    ./secrets.nix
  ];

  networking.hostName = "vm-aarch64";

  # Enable Hyprland via the Hyprland flake's NixOS module
  # (aarch64 build of the Hyprland flake package)
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Home Manager
  home-manager.users.linus = import ../../users/linus/home.nix;

  # Run x86_64 binaries inside the VM via binfmt (e.g. for cross-builds)
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # VMware Fusion guest tools: clipboard sync, display resize, shared folders
  virtualisation.vmware.guest.enable = true;

  # Some aarch64 packages claim unsupported but work fine
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "26.05";
}
