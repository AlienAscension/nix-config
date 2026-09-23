# VM hardware config for VMware Fusion on Apple Silicon (aarch64).
# Simple ext4 root + vfat boot, no LUKS (it's a VM).
# Mirrors the structure of mitchellh/nixos-config's machines/hardware/vm-aarch64.nix.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ahci" "xhci_pci" "nvme" "usbhid" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [ ];

  # Mount the macOS host ~/Downloads via VMware hgfs at the guest's
  # ~/Downloads. Requires a shared folder named "Downloads" in the VM's
  # Fusion settings (Settings -> Sharing). uid is linus (1000); gid is the
  # "users" group (100).
  #
  # nofail + x-systemd.automount: don't block boot if the share isn't
  # configured, and mount on first access.
  fileSystems."/home/linus/Downloads" = {
    device = ".host:/Downloads";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = [
      "umask=22"
      "uid=1000"
      "gid=100"
      "allow_other"
      "auto_unmount"
      "nofail"
      "x-systemd.automount"
    ];
  };
}
