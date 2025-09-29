{
  inputs,
  lib,
  config,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    ../common/default.nix
    ./disk-configuration.nix
    ./networking.nix
    ./tailscale.nix
  ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_scsi"
    "sr_mod"
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/tailnet01/secrets.yaml;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = "25.11";
}
