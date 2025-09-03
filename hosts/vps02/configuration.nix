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
  ];

  boot.initrd.availableKernelModules = [ "virtio_scsi" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.binfmt.emulatedSystems = [
    "wasm32-wasi"
    "x86_64-windows"
    "aarch64-linux"
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/vps02/secrets.yaml;

  services.nginx.enable = true;

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
    pkgs.git
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
