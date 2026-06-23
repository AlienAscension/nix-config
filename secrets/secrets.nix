let
  # Host SSH public keys — fill these in after first boot of each machine.
  # Read with: cat /etc/ssh/ssh_host_ed25519_key.pub
  desktop_host_key = "ssh-ed25519 AAAA...replace...with...desktop...pubkey";
  laptop_host_key = "ssh-ed25519 AAAA...replace...with...laptop...pubkey";

  # User SSH public keys — fill these in after generating keys.
  linus_user_key = "ssh-ed25519 AAAA...replace...with...linus...pubkey";

  # Future: work_user_key = "ssh-ed25519 AAAA...";
  # Future: work_laptop_host_key = "ssh-ed25519 AAAA...";
in
{
  "linus-ssh-private-key.age".publicKeys = [
    desktop_host_key
    laptop_host_key
    linus_user_key
  ];

  # Future, when work laptop arrives:
  # "work-ssh-private-key.age".publicKeys = [
  #   work_laptop_host_key
  #   work_user_key
  # ];
}