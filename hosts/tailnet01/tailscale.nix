{
  config,
  lib,
  ...
}:
let
  tags = [
    "freebox"
  ];
  routes = [
    "192.168.10.0/24"
    "192.168.27.64/27"
  ];
in
{
  sops.secrets."tailscale/preauth_key" = { };

  services.tailscale = {
    enable = true;

    authKeyFile = config.sops.secrets."tailscale/preauth_key".path;
    useRoutingFeatures = "server";
    extraUpFlags = [
      "--login-server=https://headscale.vfd.ovh"
      "--advertise-exit-node"
      "--advertise-routes=${lib.concatStringsSep "," routes}"
      "--advertise-tags=${lib.concatMapStringsSep "," (x: "tag:${x}") tags}"
    ];

    openFirewall = true;
  };

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
}
