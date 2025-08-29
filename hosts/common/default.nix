{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./nix.nix
    ./no-default.nix
    ./locale.nix
    ./ssh.nix
    ./firewall.nix
  ];
}
