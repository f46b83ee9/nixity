{
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

  services.nginx.enable = true;

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "25.11";
}
