{
  # LUKS — encrypted root
  # UUIDs must be filled in after partitioning during install.
  # This is a placeholder; replace with actual UUIDs.
  boot.initrd.luks.devices = {
    "cryptroot" = {
      device = "/dev/disk/by-uuid/c7326fca-74e2-451e-8310-51f4462aa41b";
      allowDiscards = true;
    };
  };

  # Filesystems — btrfs subvolumes
  # UUIDs must be filled in after formatting during install.
  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };
    "/home" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };
    "/nix" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };
    "/persist" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=@persist" "compress=zstd" "noatime" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6E74-7A53";
      fsType = "vfat";
    };
  };

  # Btrfs support
  boot.supportedFilesystems = [ "btrfs" ];

  # Swap — zram
  zramSwap.enable = true;
}
