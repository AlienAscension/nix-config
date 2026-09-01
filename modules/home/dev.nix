{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Kubernetes tooling
    kubectl
    krew
    kubernetes-helm
    kustomize
    k9s
    kubie
    kubecolor
    talosctl
    velero
    fluxcd
    cilium-cli
    hubble
    krew
    zed-editor
    opencode

    # Development
    go
    golangci-lint

    # Infrastructure
    opentofu
    sops

    # Podman desktop
    podman-desktop
  ];
}
