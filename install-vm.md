# Installing NixOS in a VM on Apple Silicon (MacBook Pro M5)

This guide sets up a NixOS VM on an Apple Silicon Mac using VMware Fusion, then applies this flake's `vm-aarch64` configuration. The VM is aarch64, runs Hyprland, and can emulate x86_64 binaries via binfmt.

Inspired by Mitchell Hashimoto's nixos-config VM workflow.

## What this config gives you

- aarch64 NixOS guest on VMware Fusion
- Hyprland (with a GNOME fallback noted below)
- Home Manager for the `linus` user
- x86_64 binary emulation via binfmt (run/cross-build x86_64 if needed)
- VMware guest tools (clipboard sync, display resize, optional shared folders)
- Simple ext4 root + vfat boot (no LUKS — it's a VM)

## Prerequisites

- NixOS aarch64 ISO from https://nixos.org/download (pick the aarch64 ISO)
- VMware Fusion installed on the Mac (free for personal use)

## 1. Create the VM

In VMware Fusion, create a new VM from the NixOS aarch64 ISO with these settings:

- **Boot mode:** UEFI
- **Disk:** SATA, 150 GB+
- **CPU:** at least half your cores
- **Memory:** at least half your RAM (as much as you can spare)
- **Graphics:** full acceleration, full resolution, maximum graphics RAM
- **Network:** shared with the Mac (NAT)
- **Remove:** sound card, video camera, printer
- **Profile:** disable almost all host keybindings (so they don't conflict with the VM)

## 2. Boot & set root password

Boot the VM. In the graphical console:

```sh
sudo su
passwd          # set to "root" (temporary, for bootstrap)
```

## 3. Verify the disk

```sh
ls /dev/sda
```

With a SATA disk, `/dev/sda` should exist. If you see `/dev/nvme*` or `/dev/vda` instead, the disk type differs — the partition commands below use `/dev/sda`; substitute your device.

## 4. (Optional) Snapshot

Take a VMware snapshot named `prebootstrap` so you can roll back if the install goes wrong.

## 5. Bootstrap install

This installs a minimal NixOS on the VM disk so we can then apply this flake. Run inside the VM as root:

```sh
# Partition: ESP (1MB-512MB), root (512MB--8GB), swap (-8GB-100%)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart primary 512MB -8GB
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

# Format
mkfs.fat -F 32 -n boot /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
mkswap -L swap /dev/sda3

# Mount
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Generate a minimal config
nixos-generate-config --root /mnt
```

Now patch `/mnt/etc/nixos/configuration.nix` to enable flakes and SSH with root login for the bootstrap. Add these lines inside the existing `{ ... }`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
services.openssh.enable = true;
services.openssh.settings.PasswordAuthentication = true;
services.openssh.settings.PermitRootLogin = "yes";
users.users.root.initialPassword = "root";
```

Then install and reboot:

```sh
nixos-install --no-root-passwd
reboot
```

## 6. Find the VM's IP

After reboot, log in as root (password `root`) and run:

```sh
ifconfig
```

Note the IP of the first interface (probably `192.168.X.X`).

## 7. Copy this repo into the VM

From your Mac (or wherever the repo lives), copy it into the VM. Replace `VMIP` with the IP from step 6:

```sh
export VMIP=192.168.X.X
rsync -av -e 'ssh -o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' \
  --exclude='.git/' \
  /path/to/nixos-config/ root@$VMIP:/nix-config
```

(If `rsync` isn't on the Mac, `scp -r` works too.)

## 8. Apply this flake

SSH into the VM and switch to the `vm-aarch64` configuration:

```sh
ssh -o PubkeyAuthentication=no root@$VMIP
cd /nix-config
nixos-rebuild switch --flake .#vm-aarch64
```

Reboot:

```sh
reboot
```

## 9. First login

Log in as `linus` (set a password first from a root TTY: `passwd linus`). Hyprland starts on login.

## 10. Post-install

Same agenix / p10k / krew steps as the physical guide, but use the `vm-aarch64` host key:

```sh
cat /etc/ssh/ssh_host_ed25519_key.pub
```

Add it to `secrets/secrets.nix` as `vm_aarch64_host_key`, add it to the relevant `publicKeys`, commit, pull on the VM, and `nh os switch .`.

### Git user email

The git username (`AlienAscension`) is set declaratively by Home Manager. The email is private and not committed to this repo — set it manually:

```sh
git config --global user.email <your-email>
```

## 11. Hyprland fallback

Hyprland in an aarch64 VM depends on VMware Fusion's 3D acceleration. If Hyprland doesn't render correctly, switch to GNOME as a fallback. In `machines/vm-aarch64/configuration.nix`, replace the Hyprland block with:

```nix
services.xserver = {
  enable = true;
  xkb.layout = "us";
  desktopManager.gnome.enable = true;
  displayManager.gdm.enable = true;
};
```

Then `nh os switch .` again.

## 12. (Optional) Shared host folder

To mount your macOS home directory inside the VM via VMware hgfs, uncomment the `/host` `fileSystems` block in `machines/vm-aarch64/hardware.nix` and rebuild. This requires VMware guest tools to be working (they're enabled by default in this config).

## Rebuilding later

```sh
nh os switch .   # from inside the VM, in /nix-config
nh os test .
nh os build .
```
