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

  # Snapper for automated snapshots (nixpkgs 26.05 API: no enable, snapshotInterval)
  services.snapper = {
    snapshotInterval = "hourly";
    configs = {
      root = {
        SUBVOLUME = "/";
        APPEND_QUOTA_GROUPS = "yes";
        SPACE_LIMIT = "0.5";
        FREE_LIMIT = "0.2";
        TIMELINE_CREATE = true;
        TIMELINE_CLEAN = true;
        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "10";
        TIMELINE_LIMIT_WEEKLY = "0";
        TIMELINE_LIMIT_MONTHLY = "10";
        TIMELINE_LIMIT_YEARLY = "10";
      };
    };
  };
}
