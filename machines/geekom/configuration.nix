{ pkgs, ... }:

{
  imports = [
    ../../modules/hardware/intel.nix
    ../../modules/hardware/bluetooth.nix
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Latest kernel (7.2+) — required for the Steam Frame wireless adapter's
  # in-tree rtw89_8852cu driver; the default 6.18 kernel lacks it.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # The Steam Frame dongle streams on the 6 GHz band, which the world regulatory
  # domain (00) excludes. cfg80211 is a module, so a kernel cmdline regdom lands
  # too early — set it at module load instead.
  boot.extraModprobeConfig = "options cfg80211 ieee80211_regdom=DE";

  # iw — needed by Valve's frame-dongle-troubleshoot.sh to inspect the link.
  # lutris — game launcher (Wine/Steam/emulators) for this box.
  environment.systemPackages = [ pkgs.iw pkgs.lutris ];

  # i2c access for ddcutil (external monitor brightness via DDC/CI)
  hardware.i2c.enable = true;

  system.stateVersion = "26.05";
}
