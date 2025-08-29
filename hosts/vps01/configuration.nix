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
    ./secrets.nix
    ./wireguard.nix
    ./services/headscale.nix
  ];

  networking.hostName = "vps01";
  networking.domain = "vfd.ovh";

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
  ];

  system.stateVersion = "25.11";
}
