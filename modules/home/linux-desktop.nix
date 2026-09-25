{ pkgs, ... }:

{
  imports = [
    ./apps.nix
  ];

  # Linux desktop file manager and USB auto-mounting
  home.packages = with pkgs; [
    thunar
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  # Pinentry for Linux (Qt variant)
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;
}
