# NixOS Hyprland Flake

NixOS configuration managed with flakes, Home Manager, Hyprland, and agenix.

## Machines

| Target | Hardware | Arch |
|--------|----------|------|
| `desktop` | Intel i7-8700K + NVIDIA RTX 2070 | x86_64 |
| `laptop` | AMD Ryzen 5 5500U | x86_64 |
| `geekom` | Geekom IT13 Max (Intel Ultra 9-185H, 24GB LPDDR) | x86_64 |
| `vm-aarch64` | NixOS VM on Apple Silicon (MacBook Pro M5, VMware Fusion) | aarch64 |

## Installation

- **Physical machines** (desktop, laptop, geekom): see [`install-physical.md`](install-physical.md)
- **Apple Silicon VM** (vm-aarch64): see [`install-vm.md`](install-vm.md)

## Rebuilding

```sh
nh os switch .   # rebuild + switch
nh os test .     # rebuild + test (non-persistent)
nh os build .    # build only
```

## Post-install

### SSH host keys (for agenix)
1. `cat /etc/ssh/ssh_host_ed25519_key.pub`
2. Add to `secrets/secrets.nix` as `<host>_host_key`
3. `git commit && nh os switch .`

### Secrets
1. `nix profile install github:ryantm/agenix`
2. `agenix -e secrets/<secret>.age`
3. Uncomment the `age.secrets` block in `machines/<host>/secrets.nix`
4. `nh os switch .`

### p10k
`p10k configure` on first login.

### krew
`kubectl krew install klock`
