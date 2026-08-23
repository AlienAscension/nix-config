let
  # Machine SSH host keys.
  # These are agenix recipients: machines whose host key can decrypt
  # the corresponding secret.

  desktop_host_key =
    "ssh-ed25519 AAAA...replace...with...desktop...pubkey";

  laptop_host_key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAfe+S87+IdXbubNe1q4EXmYpoeh49XiTM1KN1Zmiln";

  geekom_host_key =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqe5eQYE9f2Bm/W2nXbF6ymjqhlMv9Ibh19q+JJgiar";

  vm_aarch64_host_key =
    "ssh-ed25519 AAAA...replace...with...vm-aarch64...pubkey";
in
{
  # Personal Git credentials:
  # GitLab, Codeberg, personal Forgejo, etc.
  "ssh-personal-git.age".publicKeys = [
    desktop_host_key
    laptop_host_key
    geekom_host_key
  ];

  # Personal homelab credentials:
  # NAS, Raspberry Pi, servers, etc.
  "ssh-personal-homelab.age".publicKeys = [
    desktop_host_key
    laptop_host_key
    geekom_host_key
  ];

  # Future work credentials:
  #
  # "ssh-work-git.age".publicKeys = [
  #   work_laptop_host_key
  #   vm_aarch64_host_key
  # ];
  #
  # "ssh-work-server.age".publicKeys = [
  #   work_laptop_host_key
  #   vm_aarch64_host_key
  # ];
}