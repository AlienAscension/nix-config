{ pkgs, ... }:

{
  # Intel i915 (Meteor Lake / Intel Arc integrated) — modesetting driver
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics.enable = true;

  environment.systemPackages = with pkgs; [
    intel-media-driver
    vulkan-tools
    intel-gpu-tools
    mesa-demos
  ];

  # Meteor Lake VAAPI via intel-media-driver (i915 driver path)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i915";
  };
}
