{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/default.nix
    ./disk-configuration.nix
    ./hardware-overlay.nix
    ./networking.nix
    ./backup.nix
    ./services/pocket-id.nix
    ./services/cloudflared.nix
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
  
  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "console=ttyAMA0,115200n8"
    "console=tty0"
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usbhid"
    "usb_storage"
    "vc4"
    "pcie_brcmstb" 
    "reset-raspberrypi"
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/rpi01/secrets.yaml;

  services.nginx.enable = true;

  environment.systemPackages = [
    pkgs.libraspberrypi
    pkgs.raspberrypi-eeprom
    pkgs.ubootRaspberryPi4_64bit

    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "*rpi-4-*.dtb";
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllHardware = lib.mkForce false;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
