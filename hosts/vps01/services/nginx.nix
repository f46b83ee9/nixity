{
  config, 
  ...
}:
{
  services.nginx.enable = true;

  services.nginx.virtualHosts."headscale.vfd.ovh" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations."/headscale." = {
      extraConfig = ''
        grpc_pass grpc://${toString config.services.headscale.settings.grpc_listen_addr};
      '';

      priority = 1;
    };

    locations."~ ^/(?:metrics|debug)(?:$|/)" = {
      proxyPass = "http://${toString config.services.headscale.settings.metrics_listen_addr}";
      extraConfig = ''
        allow 192.168.10.0/24;    # LAN
        allow 192.168.27.64/27;   # Wireguard
        allow 100.64.0.0/16;      # Tailnet
        deny all;
      '';

      priority = 2;
    };

    locations."/admin(?:$|/)" = {
      proxyPass = "http://127.0.0.1:${toString config.services.headplane.settings.server.port}";
      proxyWebsockets = true;

      priority = 3;
    };

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
      proxyWebsockets = true;

      extraConfig = ''
        add_header 'Access-Control-Allow-Headers' '*';
        add_header 'Access-Control-Max-Age' '100';
        add_header 'Access-Control-Allow-Origin' 'https://headscale.vfd.ovh';
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT';
        add_header 'Vary' 'Origin' always;

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
      access_log /var/log/nginx/headscale.vfd.ovh.access.log;
    '';
  };

  sops.secrets."cloudflare/env" = {
    sopsFile = ../../../secrets/common/cloudflare.yaml;
  };

  security.acme.acceptTerms = true;

  security.acme.defaults = {
      email = "me@vfd.ovh";

      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";

      environmentFile = config.sops.secrets."cloudflare/env".path;
      
      group = config.services.nginx.group;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}