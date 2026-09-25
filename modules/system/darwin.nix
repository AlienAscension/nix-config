{ ... }:

{
  # Platform-specific darwin system settings.
  # Start minimal; Dock/keyboard/trackpad/Mission Control defaults can grow here
  # in follow-up iterations.

  nixpkgs.config.allowUnfree = true;

  # opencode is a Bun-compiled binary (bin/.opencode-wrapped) whose linker
  # signature is invalid on aarch64-darwin under macOS 27. The kernel validates
  # code-signature page hashes on first touch and SIGKILLs the process ("Code
  # Signature Invalid", cs_invalid_page) at the __LINKEDIT page.
  #
  # We cannot fix this with `overrideAttrs { postFixup = codesign ...; }`: that
  # forces a source rebuild, and the upstream build runs a smoke test on the
  # freshly built (still-invalid) binary, so the build fails before postFixup.
  # Instead, repack the substitutable build output: copy the real binary out of
  # it, re-sign the copy, and regenerate the wrapper so it points at the copy.
  # Ad-hoc signing is sufficient; no entitlements/hardened runtime are needed.
  nixpkgs.overlays = [
    (final: prev: {
      opencode = prev.runCommand "opencode-${prev.opencode.version}-signed" {
        nativeBuildInputs = [ prev.makeBinaryWrapper ];
        passthru = prev.opencode.passthru or { };
        meta = prev.opencode.meta or { };
      } ''
        mkdir -p $out/bin
        cp -R ${prev.opencode}/share $out/share

        cp ${prev.opencode}/bin/.opencode-wrapped $out/bin/.opencode-wrapped
        chmod u+w $out/bin/.opencode-wrapped
        /usr/bin/codesign --force --sign - $out/bin/.opencode-wrapped

        makeWrapper $out/bin/.opencode-wrapped $out/bin/opencode \
          --inherit-argv0 \
          --prefix PATH : ${prev.lib.makeBinPath (
            [ prev.ripgrep ]
            ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [ prev.sysctl ]
          )}
      '';
    })
  ];

  # Keep the native menu bar visible.
  system.defaults.NSGlobalDomain._HIHideMenuBar = false;

  # Keyboard
  # Caps Lock is handled by Karabiner instead (tap = Escape, hold = AeroSpace
  # Hyper); the system-level HID remap would fight it, so leave it off.
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;
}
