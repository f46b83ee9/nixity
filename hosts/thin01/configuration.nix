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
    "${modulesPath}/installer/scan/not-detected.nix"
    ../common/default.nix
    ./disk-configuration.nix
    ./networking.nix
    ./backup.nix
    ./services/nginx.nix
    ./services/forgejo.nix
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "ohci_pci"
    "ehci_pci"
    "pata_atiixp"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ "dm-snapshot" ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/thin01/secrets.yaml;

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
