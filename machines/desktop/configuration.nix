{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/system/default.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix
    ./hardware.nix
    ./secrets.nix
  ];

  networking.hostName = "desktop";

  # Enable Hyprland via the Hyprland flake's NixOS module
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Home Manager
  home-manager.users.linus = import ../../users/linus/home.nix;

  # Intel CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  system.stateVersion = "26.05";
}