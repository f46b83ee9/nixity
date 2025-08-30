{
  config,
  pkgs,
  ...
}:
let
  base_domain = "vfd.ovh";
  server_url = "ztna.${base_domain}";
in
{
  services.headscale = {
    enable = true;

    address = "127.0.0.1";
    port = 8080;

    settings = {
      server_url = "https://${server_url}";

      grpc_listen_addr = "127.0.0.1:50443";
      grpc_allow_insecure = true;

      metrics_listen_addr = "127.0.0.1:9090";

      dns = {
        magic_dns = true;
        base_domain = "tailnet.${base_domain}";

        nameservers.global = [
          "1.1.1.3"
          "1.0.0.3"
        ];

        nameservers.split."vfd.ovh" = [
          "192.168.10.215"
        ];
      };
    };
  };

  services.nginx.enable = true;

  services.nginx.virtualHosts."${server_url}" = {
    forceSSL = true;
    enableACME = true;

    locations."/headscale." = {
      extraConfig = ''
        grpc_pass grpc://${config.services.headscale.settings.grpc_listen_addr};
      '';

      priority = 1;
    };

    locations."~ ^/(?:metrics|debug)(?:$|/)" = {
      proxyPass = "http://${config.services.headscale.settings.metrics_listen_addr}";
      extraConfig = ''
        allow 192.168.10.0/24;    # LAN
        allow 192.168.27.64/27;   # Wireguard
        allow 100.64.0.0/16;      # Tailnet
        deny all;
      '';

      priority = 2;
    };

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
      extraConfig = ''
        keepalive_requests          100000;
        keepalive_timeout           160s;
        proxy_buffering             off;
        proxy_connect_timeout       75;
        proxy_ignore_client_abort   on;
        proxy_read_timeout          900s;
        proxy_send_timeout          600;
        send_timeout                600;
      '';

      priority = 99;
    };

    extraConfig = ''
      access_log /var/log/nginx/${server_url}.access.log;
    '';
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@${base_domain}";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    3478 # STUN Derp
  ];
}
