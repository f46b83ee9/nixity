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
    ./services/headscale.nix
  ];

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
