{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "helm"
        "kubectl"
        "fluxcd"
      ];
      custom = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      theme = "powerlevel10k";
    };

    shellAliases = {
      # Git
      gad = "git add .";
      gcm = "git commit -m";
      gp = "git push";
      gs = "git status";
      gsw = "git switch";
      gswc = "git switch -c";
      glg = "git log --graph --abbrev-commit --decorate --format=format:'%C(#c4a7e7)%h%C(reset) - %C(#9ccfd8)%aD%C(reset) %C(#908caa)(%ar)%C(reset)%C(#f6c177)%d%C(reset)%n'\\'' %C(#e0def4)%s%C(reset) %C(#6e6a86)- %an%C(reset)' --all";

      # Kubernetes
      k = "kubectl";
      ctx = "kubie ctx";
      kk = "kubectl klock";

      # Flux
      frs = "flux reconcile source git flux-system";
      fgk = "flux get kustomizations -A";
      fgh = "flux get hr -A";

      # Directory navigation
      kws = "cd ~/Dokumente/kubernetes/";
      kwsf = "cd ~/Dokumente/kubernetes/fluxcd/";
      cdk8 = "cd ~/git/k8s-homelab/";
      cdocs = "cd ~/git/docs-homelab/";

      # lsd
      l = "lsd -1";
      la = "lsd -1a";
      ls = "lsd";

      # Editor
      v = "nvim";
      zshrc = "nvim ~/.zshrc";
    };

    initExtraFirst = ''
      # Invalidate zcompdumps when the set of zsh completion files changes.
      # compinit reuses its dump whenever only the *number* of completion
      # files matches, so a 1-for-1 package swap (passage -> pass) silently
      # keeps the stale dump and the new package's completions never load.
      _zcomp_stamp="$HOME/.cache/zsh/.completions-fingerprint"
      mkdir -p "$_zcomp_stamp:h"
      _zcomp_fp="$({ for p in ''${(z)NIX_PROFILES}; do ls -1 "$p/share/zsh/site-functions" 2>/dev/null; done; } | sort | md5sum | cut -d' ' -f1)"
      if [[ ! -f "$_zcomp_stamp" || "$(<$_zcomp_stamp)" != "$_zcomp_fp" ]]; then
        rm -f "$HOME"/.zcompdump*(N) "$HOME"/.cache/oh-my-zsh/completions/.zcompdump*(N)
      fi
      print -r -- "$_zcomp_fp" >| "$_zcomp_stamp"
      unset _zcomp_stamp _zcomp_fp
    '';

    initContent = ''
      # pass
      export PASSWORD_STORE_DIR="$HOME/git/pass"

      # kubecolor: wrap kubectl with colored output
      alias kubectl=kubecolor
      compdef kubecolor=kubectl

      # atuin
      eval "$(atuin init zsh)"

      # krew
      export PATH="''${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

      # Go
      export PATH="$HOME/.local/go/bin:$HOME/go/bin:$PATH"
    '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    
    settings = {
    user = {
      name = "AlienAscension";
      email = "148532831+AlienAscension@users.noreply.github.com";
    };
  };
};

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    mouse = true;
    terminal = "xterm-256color";
    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
    enableZshIntegration = true;
    extraConfig = ''
      default-cache-ttl 3600
      max-cache-ttl 86400
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        User = "git";
        HostName = "github.com";
        IdentityFile = "/run/agenix/ssh-personal-git";
        IdentitiesOnly = true;
      };

      "codeberg.org" = {
        User = "AlienAscension";
        HostName = "codeberg.org";
        IdentityFile = "/run/agenix/ssh-personal-git";
        IdentitiesOnly = true;
      };

      "git.lindabre.de" = {
        User = "git";
        HostName = "git.lindabre.de";
        Port = 2222;
        IdentityFile = "/run/agenix/ssh-personal-git";
        IdentitiesOnly = true;
      };

      "raspi" = {
        HostName = "192.168.0.36";
        User = "admin";
        IdentityFile = "/run/agenix/ssh-personal-homelab";
        IdentitiesOnly = true;
      };

      "nas" = {
        HostName = "192.168.0.34";
        User = "admin";
        IdentityFile = "/run/agenix/ssh-personal-homelab";
        IdentitiesOnly = true;
    };
  };
};

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    eza
    bat
    git-filter-repo
    gh
    pass
    tree
    duf
    tldr
    pv
    rsync
    unzip
    p7zip
    lsd
    yazi
    thunar
    udiskie
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}