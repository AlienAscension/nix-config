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
  "./secrets/ssh-personal-git.age".publicKeys = [
    desktop_host_key
    laptop_host_key
    geekom_host_key
  ];

  "./secrets/ssh-personal-homelab.age".publicKeys = [
    desktop_host_key
    laptop_host_key
    geekom_host_key
  ];
}