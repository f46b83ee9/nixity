{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.sops
    pkgs.yq
    pkgs.caligula
    pkgs.zstd
    pkgs.qemu
    pkgs.k9s
    pkgs.nixfmt
    pkgs.kubectl
    pkgs.kubelogin-oidc
    pkgs.restic
    pkgs.yubikey-manager
    pkgs.openssh
    pkgs.opkssh
  ];

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings.experimental-features = "nix-command flakes";

  nix.settings.allowed-users = [
    "@admin"
    "root"
  ];

  nix-rosetta-builder.onDemand = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
}
