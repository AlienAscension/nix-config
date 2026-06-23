{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32 = true;
  };

  environment.systemPackages = with pkgs; [
    mesa-utils
    radeontop
  ];
}