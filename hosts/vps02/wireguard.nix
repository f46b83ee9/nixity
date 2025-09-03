{
  config,
  ...
}:
{
  sops.secrets."wireguard/private_key" = { };

  networking.wireguard.enable = true;

  networking.wireguard.interfaces = {
    wireguard0 = {
      privateKeyFile = config.sops.secrets."wireguard/private_key".path;

      ips = [ "192.168.27.76/32" ];
      listenPort = 7281;
      mtu = 1360;

      peers = [
        {
          publicKey = "FkUggCV130D7yRfNREEG02T/J4qJRa4SJj3iqYttpBI=";
          allowedIPs = [
            "192.168.27.64/27"
            "192.168.10.0/24"
          ];
          endpoint = "82.66.161.43:7281";
          persistentKeepalive = 5;
        }
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 7281 ];
  };

  networking.firewall.trustedInterfaces = [ "wireguard0" ];
}
