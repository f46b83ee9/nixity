{
  modulesPath,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/default.nix
    ./disk-configuration.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./secrets.nix
    ./wireguard.nix
    ./backup.nix
    ./services/headscale.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.restic
  ];

  system.stateVersion = "25.11";
}
