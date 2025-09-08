{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../common/default.nix
    ./disk-configuration.nix
    ./networking.nix
    ./wireguard.nix
    ./backup.nix
    ./services/nginx.nix
    ./services/headscale.nix
  ];

  boot.initrd.availableKernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [ "kvm-intel" ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/vps01/secrets.yaml;

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  nixpkgs.overlays = [ inputs.headplane.overlays.default ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
