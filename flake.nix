{
  description = "NixOS configuration with Hyprland for desktop, laptop, geekom, and aarch64 VM";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Extra channel used only to cherry-pick newer packages via overlay
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.55.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    # Noctalia desktop shell — pinned to the `cachix` branch (latest CI-cached commit).
    # NOTE: deliberately NO `inputs.nixpkgs.follows` here — following nixpkgs changes the
    # derivation hash and disables the noctalia binary cache. See modules/system/default.nix.
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };

    # Noctalia Greeter (greetd greeter) — no documented binary cache, so follows nixpkgs.
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    # Kubernetes TUI. Pinned to a release tag, and deliberately NO
    # `inputs.nixpkgs.follows`: upstream warms its `nkl-sofka` Cachix cache for
    # the tagged rev using its own nixpkgs rev, so following ours would change
    # every dependency hash and miss that cache. See modules/system/default.nix.
    sofka = {
      url = "github:nklmilojevic/sofka/v0.25.3";
    };

    # nono — kernel-enforced sandbox for AI agents (Claude Code, opencode, …).
    # We consume the `prebuilt` output: `default` builds the Rust crate from
    # source on every bump, whereas `prebuilt` just fetches upstream's release
    # tarball. `nixpkgs` follows ours because the prebuilt derivation only needs
    # stdenv/fetchurl. See modules/system/darwin.nix.
    #
    # Tracking `main` (rev pinned in flake.lock) rather than a release tag: the
    # v0.79.0 tag's baked-in aarch64-darwin tarball hash is stale (upstream's
    # release job refreshes hashes on main after tagging), so `#prebuilt` fails
    # the fixed-output hash check on that tag.
    nono = {
      url = "github:nolabs-ai/nono";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { nixpkgs, home-manager, hyprland, agenix, ... }:
    let
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs; };
      mkDarwin = import ./lib/mkdarwin.nix { inherit nixpkgs inputs; };
    in
    {
      nixosConfigurations.desktop = mkSystem "desktop" { system = "x86_64-linux"; };
      nixosConfigurations.laptop = mkSystem "laptop" { system = "x86_64-linux"; };
      nixosConfigurations.geekom = mkSystem "geekom" { system = "x86_64-linux"; };
      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" { system = "aarch64-linux"; };

      darwinConfigurations.macbook = mkDarwin "macbook" { system = "aarch64-darwin"; user = "lbr"; };
    };
}
