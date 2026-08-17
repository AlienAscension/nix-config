{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/system/default.nix
    ../../modules/hardware/intel.nix
    ../../modules/hardware/bluetooth.nix
    ./hardware.nix
    ./secrets.nix
  ];

  networking.hostName = "geekom";

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
