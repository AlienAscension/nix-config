{ ... }:

{
  imports = [
    ../../modules/hardware/amd.nix
    ../../modules/hardware/bluetooth.nix
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Laptop power management
  services.power-profiles-daemon.enable = true;

  system.stateVersion = "26.05";
}