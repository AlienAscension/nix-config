# NixOS Hyprland Flake

NixOS configuration for desktop (Intel i7-8700K + NVIDIA RTX 2070) and laptop (AMD Ryzen 5 5500U).

## Fresh Install

1. Boot NixOS ISO
2. Partition disk: EFI (512MB FAT32), root (rest, encrypted with LUKS)
3. Format: `cryptsetup luksFormat`, `mkfs.btrfs` with subvolumes @, @home, @nix, @persist
4. Mount everything under `/mnt`
5. Generate base config: `nixos-generate-config --root /mnt`
6. Clone this repo to `/mnt/etc/nixos` (or anywhere)
7. Edit `machines/<host>/hardware.nix` — fill in real UUIDs
8. Install: `nixos-install --flake .#desktop` (or `.#laptop`)
9. Reboot, login as linus

## Post-Install

### SSH Host Keys (for agenix)
1. Read host key: `cat /etc/ssh/ssh_host_ed25519_key.pub`
2. Add to `secrets/secrets.nix` as `desktop_host_key` or `laptop_host_key`
3. `git commit && nixos-rebuild switch`

### Secrets
1. Install agenix: `nix profile install github:ryantm/agenix`
2. Edit secret: `agenix -e secrets/linus-ssh-private-key.age`
3. Uncomment age.secrets block in `machines/<host>/secrets.nix`
4. `nh os switch .`

### p10k
Run `p10k configure` to generate `~/.p10k.zsh` on first login.

### krew plugins
`kubectl krew install klock` (and any other plugins)

## Rebuilding
- `nh os switch .` — rebuild and switch to new config
- `nh os test .` — rebuild and test without making it the boot default
- `nh os build .` — just build, don't switch