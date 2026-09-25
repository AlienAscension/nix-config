{ ... }:

{
  # Platform-specific darwin system settings.
  # Start minimal; Dock/keyboard/trackpad/Mission Control defaults can grow here
  # in follow-up iterations.

  nixpkgs.config.allowUnfree = true;

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
}
