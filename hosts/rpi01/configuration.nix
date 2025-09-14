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
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../common/default.nix
    ./networking.nix
    ./backup.nix
    ./services/nginx.nix
    ./services/pocket-id.nix
    ./services/cloudflared.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.supportedFilesystems = lib.mkForce [
    "ext4"
    "vfat"
  ];

  boot.initrd.availableKernelModules = lib.mkForce [
    "mmc_block"
    "ahci"
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "vc4"
    "pcie_brcmstb" # required for the pcie bus to work
    "reset-raspberrypi" # required for vl805 firmware to load
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/rpi01/secrets.yaml;

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  hardware.enableRedistributableFirmware = true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
