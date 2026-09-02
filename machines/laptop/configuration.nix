{ inputs, pkgs, ... }:

{
  imports = [
    ../../modules/system/default.nix
    ../../modules/hardware/amd.nix
    ../../modules/hardware/bluetooth.nix
    ./hardware.nix
    ./secrets.nix
  ];

  networking.hostName = "laptop";

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

  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = true;

  # Laptop power management
  services.power-profiles-daemon.enable = true;

  system.stateVersion = "26.05";
}