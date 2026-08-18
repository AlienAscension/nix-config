{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Kubernetes tooling
    kubectl
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