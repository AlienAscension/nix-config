# Installing NixOS on a Physical Machine

This guide walks through a fresh NixOS install on any physical machine using this flake. The worked example is `geekom` (Geekom IT13 Max, Intel Ultra 9-185H), but the same steps apply to `desktop`, `laptop`, or any future physical machine target — just substitute the hostname.

## What this config gives you

- LUKS-encrypted root
- btrfs with subvolumes (`@`, `@home`, `@nix`, `@persist`) + zstd compression
- Snapper hourly snapshots
- zram swap
- Hyprland (via the Hyprland flake)
- Home Manager for the `linus` user
- agenix secrets scaffolding

## Prerequisites

- NixOS ISO (x86_64) from https://nixos.org/download
- A USB flash tool (e.g. `dd` or balenaEtcher)
- This repo accessible (another machine, or a USB stick) — you'll clone it into the chroot during install.

## 1. Boot the ISO

Flash the ISO to USB and boot the target machine from it. Once at the desktop:

```sh
sudo su
passwd          # set a root password so you can SSH in if you like
```

Make sure networking is up (the ISO uses NetworkManager by default; the GUI applet works).

## 2. Partition the disk

Identify your disk with `lsblk`. This guide assumes `/dev/nvme0n1`; substitute as needed.

```sh
DISK=/dev/nvme0n1

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MB 512MB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart primary 512MB 100%
```

This creates an EFI partition (partition 1, 512MB) and a root partition (partition 2, the rest).

## 3. Encrypt & format

```sh
# LUKS-encrypt the root partition
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptroot

# Format the LUKS device as btrfs
mkfs.btrfs /dev/mapper/cryptroot

# Create subvolumes
mount /dev/mapper/cryptroot /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
umount /mnt
```

Format the EFI partition:

```sh
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
```

## 4. Mount everything under /mnt

```sh
mount -o subvol=@,compress=zstd,noatime /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{home,nix,persist,boot}
mount -o subvol=@home,compress=zstd,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=@nix,compress=zstd,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=@persist,compress=zstd,noatime /dev/mapper/cryptroot /mnt/persist
mount /dev/nvme0n1p1 /mnt/boot
```

## 5. Discover the UUIDs you need

The machine's `hardware.nix` needs two UUIDs: the LUKS partition and the boot partition.

```sh
blkid
```

Note:
- the UUID of `/dev/nvme0n1p2` (the LUKS partition) → goes in `boot.initrd.luks.devices.cryptroot.device`
- the UUID of `/dev/nvme0n1p1` (the EFI partition) → goes in `fileSystems."/boot".device`

## 6. Generate a throwaway base config (optional, for cross-checking)

```sh
nixos-generate-config --root /mnt
```

This writes `/mnt/etc/nixos/hardware-configuration.nix` which you can use to double-check the UUIDs and subvolume mounts. You will NOT use this config — you'll clone this repo instead. You can delete `/mnt/etc/nixos` afterward.

## 7. Clone this repo into the chroot

```sh
cd /mnt
git clone <your-repo-url> etc/nixos   # or copy from a USB stick
cd etc/nixos
```

## 8. Fill in the UUIDs

Edit `machines/geekom/hardware.nix` (or the relevant machine) and replace the two placeholders:

```nix
boot.initrd.luks.devices."cryptroot".device =
  "/dev/disk/by-uuid/REPLACE-WITH-ENCRYPTED-PARTITION-UUID";   # ← partition UUID from blkid

fileSystems."/boot".device =
  "/dev/disk/by-uuid/REPLACE-WITH-BOOT-PARTITION-UUID";        # ← EFI partition UUID from blkid
```

The btrfs subvolume mounts use `/dev/mapper/cryptroot` and don't need UUIDs.

## 9. Install

```sh
nixos-install --flake .#geekom
```

(Substitute `.#desktop`, `.#laptop`, etc. for other machines.)

When prompted, set the root password. Then reboot:

```sh
reboot
```

## 10. First login

Log in as `linus` (no password is set yet — use `sudo passwd linus` from a TTY, or set one before rebooting). The Hyprland session starts on login.

## 11. Post-install

### SSH host key (for agenix)

agenix encrypts secrets to each host's SSH key. Add this machine's key so it can decrypt its secrets:

```sh
cat /etc/ssh/ssh_host_ed25519_key.pub
```

On another machine that has the repo, add that key to `secrets/secrets.nix` as `geekom_host_key` (or the matching name), add it to the `publicKeys` list of each secret this host should decrypt, commit, and push. Back on the new machine:

```sh
cd /etc/nixos
git pull
nh os switch .
```

### agenix secrets

If you have existing `.age` secrets this host should receive:

```sh
nix profile install github:ryantm/agenix
agenix -e secrets/linus-ssh-private-key.age   # re-encrypt with the new host key added
```

Then uncomment the `age.secrets` block in `machines/geekom/secrets.nix` and rebuild:

```sh
nh os switch .
```

### p10k

```sh
p10k configure
```

### krew plugins

```sh
kubectl krew install klock
```

## 12. Rebuilding later

```sh
nh os switch .   # rebuild + switch (persists across reboots)
nh os test .     # rebuild + test (doesn't persist across reboot)
nh os build .    # build only
```
