{ pkgs, ... }:

{
  # Run x86_64 binaries inside the VM via binfmt (e.g. for cross-builds)
  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  # VMware Fusion guest tools: clipboard sync, display resize, shared folders
  virtualisation.vmware.guest.enable = true;

  # Needed for the VMware user tools clipboard to work reliably.
  environment.systemPackages = with pkgs; [ gtkmm3 ];

  # Some aarch64 packages claim unsupported but work fine
  nixpkgs.config.allowUnsupportedSystem = true;

  system.stateVersion = "26.05";
}
