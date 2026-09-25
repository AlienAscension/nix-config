{
  # agenix secret declarations for this host.
  # macbook's SSH host key is a recipient in ../../secrets.nix.
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  age.secrets = {
    ssh-personal-git = {
      file = ../../secrets/ssh-personal-git.age;
      owner = "lbr";
      group = "staff";
      mode = "0600";
    };

    # ssh-personal-homelab is not encrypted to macbook_host_key, so it cannot
    # be decrypted here (see ../../secrets.nix).
    # ssh-personal-homelab = {
    #   file = ../../secrets/ssh-personal-homelab.age;
    #   owner = "lbr";
    #   group = "staff";
    #   mode = "0600";
    # };
  };
}
