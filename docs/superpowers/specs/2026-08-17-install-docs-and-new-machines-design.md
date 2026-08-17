# Design: Install docs + Geekom IT13 + MacBook Pro M5 VM

**Date:** 2026-08-17
**Status:** Approved (pending spec review)

## Goal

1. Write two install walkthroughs: `install-physical.md` (generic physical-machine flow) and `install-vm.md` (Apple Silicon VM flow).
2. Add a machine config for a **Geekom IT13 Max Mini PC** (Intel Ultra 9-185H, 24GB LPDDR).
3. Add a machine config for a **NixOS VM** running on a MacBook Pro M5 (Apple Silicon, aarch64).
4. Take structural inspiration from Mitchell Hashimoto's `nixos-config` (multi-arch flake, VM bootstrap pattern) while keeping this repo's existing conventions (Hyprland, LUKS+btrfs on physical machines, agenix, `linus` user).

## Non-goals

- No nix-darwin / macOS host management.
- No WSL configuration.
- No Makefile-based remote bootstrap automation in this pass (the VM install doc describes the manual equivalent; a Makefile can be added later if desired).
- No changes to existing `desktop`/`laptop` behavior beyond what the flake refactor requires.

## Architecture

### Flake: support per-machine systems

Current `flake.nix` hardcodes `system = "x86_64-linux"` for every machine. The MacBook Pro M5 VM requires `aarch64-linux`. Introduce a small helper, `lib/mksystem.nix`, that takes `name`, `system`, and `user` and wires up `nixpkgs.lib.nixosSystem` with the shared modules and `specialArgs`. This mirrors Mitchell's `lib/mksystem.nix` but is stripped down — no darwin, no WSL, no overlays plumbing beyond what this repo already does.

`flake.nix` then declares each machine with its own system:

```
nixosConfigurations.desktop      = mkSystem "desktop"      { system = "x86_64-linux";  user = "linus"; };
nixosConfigurations.laptop       = mkSystem "laptop"       { system = "x86_64-linux";  user = "linus"; };
nixosConfigurations.geekom       = mkSystem "geekom"       { system = "x86_64-linux";  user = "linus"; };
nixosConfigurations.vm-aarch64   = mkSystem "vm-aarch64"   { system = "aarch64-linux"; user = "linus"; };
```

Shared modules stay the same: `./modules/system/default.nix`, `agenix.nixosModules.default`, `home-manager.nixosModules.home-manager`. Each machine still imports its own `configuration.nix` / `hardware.nix` / `secrets.nix`.

### New hardware module: `modules/hardware/intel.nix`

The Geekom's Ultra 9-185H is Meteor Lake with Intel Arc integrated graphics (i915). There is currently `nvidia.nix` and `amd.nix` but no Intel module. New module provides:

- `services.xserver.videoDrivers = [ "modesetting" ]` (i915 is in-tree; modesetting is the modern path).
- `hardware.graphics.enable = true` (and `enable32 = false` — no 32-bit needed on this machine by default).
- `environment.systemPackages`: `intel-media-driver`, `vulkan-tools`, `intel-gpu-tools`, `mesa-utils`.
- `environment.sessionVariables`: `LIBVA_DRIVER_NAME = "i915"` (Meteor Lake uses the i915 driver with `intel-media-driver` for VAAPI).
- No NVIDIA-specific env vars.

Structure mirrors `amd.nix`.

### Machine: `machines/geekom/` (Geekom IT13 Max)

- **`configuration.nix`**: hostname `geekom`; imports `../../modules/system/default.nix`, `../../modules/hardware/intel.nix`, `../../modules/hardware/bluetooth.nix`, `./hardware.nix`, `./secrets.nix`. Enables Hyprland via the Hyprland flake package. `home-manager.users.linus = import ../../users/linus/home.nix;`. `hardware.cpu.intel.updateMicrocode = true`. `system.stateVersion = "26.05"`.
- **`hardware.nix`**: LUKS encrypted root + btrfs subvolumes (`@`, `@home`, `@nix`, `@persist`) with placeholder UUIDs — same proven pattern as `desktop`/`laptop`. NVMe is the expected disk class but the config uses `by-uuid` so it works regardless. `zramSwap.enable = true`. Snapper config identical to the existing machines.
- **`secrets.nix`**: scaffold matching `desktop`/`laptop` (commented `age.identityPaths` + `age.secrets` block).

### Machine: `machines/vm-aarch64/` (MacBook Pro M5 VM)

- **`configuration.nix`**: hostname `vm-aarch64`; imports system module, `./hardware.nix`, `./secrets.nix`. **No `nvidia.nix`/`amd.nix`/`intel.nix`** — the VM uses virtio graphics. Enables Hyprland via the Hyprland flake package (aarch64). `home-manager.users.linus = import ../../users/linus/home.nix;`. `boot.binfmt.emulatedSystems = [ "x86_64-linux" ]` so x86_64 binaries can be cross-built/run if ever needed (matches Mitchell). `virtualisation.vmware.guest.enable = true` (VMware Fusion guest tools — clipboard, resize, shared folders). `nixpkgs.config.allowUnsupportedSystem = true` (some aarch64 packages claim unsupported but work). `system.stateVersion = "26.05"`.
- **`hardware.nix`**: simple ext4 root + vfat boot, **no LUKS** (VM; matches Mitchell's `vm-aarch64` hardware). Label-based mounts: `/` → `/dev/disk/by-label/nixos` (ext4), `/boot` → `/dev/disk/by-label/boot` (vfat). QEMU/virtio kernel modules in `boot.initrd.availableKernelModules`. `swapDevices` left to the installer (a swap partition is created during bootstrap). Optional `/host` shared folder (VMware hgfs fuse) included but **commented out** — user can enable if they want host file access.
- **`secrets.nix`**: scaffold matching the others.

**Hypervisor:** VMware Fusion primary (matches Mitchell; provides 3D acceleration on Apple Silicon). `install-vm.md` notes UTM as an alternative and points to the UTM-specific tweaks if needed later.

**Hyprland-in-VM risk:** Hyprland in an aarch64 VM depends on the hypervisor's 3D acceleration. VMware Fusion provides this on Apple Silicon. The VM install doc will note that if Hyprland misbehaves, switching to GNOME is a one-line change (`services.xserver.desktopManager.gnome.enable = true` + display manager). Default stays Hyprland for consistency with the rest of the repo.

### Install docs

#### `install-physical.md`

Generic physical-machine flow. Uses `geekom` as the worked example but explicitly notes the same steps apply to `desktop` and `laptop` (and any future physical machine).

Sections:
1. **Prerequisites** — NixOS ISO (x86_64), USB flash tool, this repo cloned somewhere accessible.
2. **Boot the ISO** — boot from USB, set root password, enable networking.
3. **Partition the disk** — EFI (512MB FAT32) + root (rest, LUKS). `parted` commands.
4. **Format & set up btrfs subvolumes** — `cryptsetup luksFormat`, `cryptsetup open`, `mkfs.btrfs`, create subvolumes `@`, `@home`, `@nix`, `@persist`.
5. **Mount everything under `/mnt`** — mount root subvol, create dirs, mount home/nix/persist/boot.
6. **Generate base config** — `nixos-generate-config --root /mnt` (only to discover UUIDs; the generated config is discarded).
7. **Clone this repo** to `/mnt/etc/nixos` (or `/mnt/nix-config`).
8. **Fill in UUIDs** in `machines/<host>/hardware.nix` — show how to read them with `blkid` / `lsblk -f`.
9. **Install** — `nixos-install --flake .#<host>` (e.g. `.#geekom`).
10. **Reboot & login** as `linus`.
11. **Post-install** — SSH host key for agenix (`cat /etc/ssh/ssh_host_ed25519_key.pub` → add to `secrets/secrets.nix` → commit → rebuild), agenix secret edit, `p10k configure`, krew plugins.
12. **Rebuilding** — `nh os switch .` / `nh os test .` / `nh os build .`.

#### `install-vm.md`

Apple Silicon VM flow. Primary hypervisor: VMware Fusion.

Sections:
1. **Prerequisites** — NixOS aarch64 ISO, VMware Fusion installed on the Mac.
2. **Create the VM** — settings list (UEFI boot, SATA disk 150GB+, half cores / half RAM, full 3D acceleration + max graphics RAM, shared network, remove sound/camera/printer, disable host keybindings). Mirrors Mitchell's recommended settings.
3. **Boot & set root password** — `sudo su`, `passwd` → `root`.
4. **Verify the disk** — `/dev/sda` should exist for SATA. Note about nvme/vda alternatives.
5. **(Optional) Snapshot** — "prebootstrap" snapshot for easy rollback.
6. **Bootstrap install** — manual partitioning (ESP fat32 1MB-512MB, root ext4 512MB--8GB, swap linux-swap -8GB-100%), `mkfs.ext4 -L nixos`, `mkswap -L swap`, `mkfs.fat -F 32 -n boot`, mount, `nixos-generate-config --root /mnt`, patch generated `configuration.nix` to enable flakes + SSH with root login + initial password, `nixos-install --no-root-passwd`, reboot. (This is the manual equivalent of Mitchell's `make vm/bootstrap0`.)
7. **Find VM IP** — `ifconfig` in the VM, note the address.
8. **Copy the repo into the VM** — `rsync` or `scp` the nixos-config repo to `/nix-config` in the VM (SSH as root, password `root`).
9. **Apply this config** — `sudo nixos-rebuild switch --flake /nix-config#vm-aarch64`.
10. **Reboot** — graphical Hyprland login.
11. **Post-install** — same agenix / p10k / krew steps as physical, adapted for `vm-aarch64` host key.
12. **Hyprland fallback note** — if Hyprland doesn't render under the hypervisor, switch to GNOME (one-line config change) and rebuild.
13. **(Optional) Shared host folder** — uncomment the `/host` `fileSystems` block in `machines/vm-aarch64/hardware.nix` to mount the macOS home directory via VMware hgfs.

### Small updates

- **`README.md`**: trim the inline install steps to a one-paragraph overview; link to `install-physical.md` and `install-vm.md`; list all four machine targets (`desktop`, `laptop`, `geekom`, `vm-aarch64`) with one-line descriptions.
- **`secrets/secrets.nix`**: add `geekom_host_key` and `vm_aarch64_host_key` placeholders; add both to the `publicKeys` of `"linus-ssh-private-key.age"`.

## Files touched / created

```
lib/mksystem.nix                      (new)
flake.nix                             (refactored to use mkSystem)
modules/hardware/intel.nix            (new)
machines/geekom/configuration.nix     (new)
machines/geekom/hardware.nix          (new)
machines/geekom/secrets.nix           (new)
machines/vm-aarch64/configuration.nix (new)
machines/vm-aarch64/hardware.nix      (new)
machines/vm-aarch64/secrets.nix       (new)
install-physical.md                   (new)
install-vm.md                         (new)
README.md                             (updated)
secrets/secrets.nix                   (updated)
```

## Verification

After implementation:

1. `nix flake check --no-build` — flake evaluates cleanly.
2. `nix eval --raw '.#nixosConfigurations.geekom.config.system.build.toplevel.drvPath'` — geekom config builds/evaluates.
3. `nix eval --raw '.#nixosConfigurations.vm-aarch64.config.system.build.toplevel.drvPath'` — vm-aarch64 config evaluates (aarch64; may not build on x86_64 host without binfmt, but eval should pass).
4. `nix eval --raw '.#nixosConfigurations.desktop.config.system.build.toplevel.drvPath'` and `.#laptop` — existing machines still evaluate (no regression).
5. Manual read-through of both install docs against the actual machine configs (UUIDs, labels, flake targets, hostnames all line up).

## Open questions / risks

- **Hyprland on aarch64 VM:** depends on hypervisor 3D accel. Mitigated by GNOME fallback note in `install-vm.md`. No code action beyond the note.
- **binfmt for aarch64 build on x86_64 host:** the geekom config is x86_64 so it builds natively on the desktop. The vm-aarch64 config is aarch64 and will be built *inside* the VM (aarch64), so no cross-build is required for normal use. `boot.binfmt.emulatedSystems` on the VM lets it run x86_64 binaries, not the other way around. No host-side cross-compilation is promised by this design.
- **VMware Fusion guest tools on aarch64:** `virtualisation.vmware.guest.enable` is supported; if it ever breaks, the install doc notes the VM still works without it (just no clipboard/resize/shared folders).
