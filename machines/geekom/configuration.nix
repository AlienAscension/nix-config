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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Home Manager
  home-manager.users.linus = import ../../users/linus/home.nix;

  # Intel CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  # i2c access for ddcutil (external monitor brightness via DDC/CI)
  hardware.i2c.enable = true;

  system.stateVersion = "26.05";
}
