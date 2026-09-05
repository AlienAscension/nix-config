{
  # Personal Git SSH key
  age.secrets.ssh-personal-git = {
    file = ../../secrets/ssh-personal-git.age;
    owner = "linus";
    group = "users";
    mode = "0600";
  };

  # Personal homelab SSH key
  age.secrets.ssh-personal-homelab = {
    file = ../../secrets/ssh-personal-homelab.age;
    owner = "linus";
    group = "users";
    mode = "0600";
  };
}
