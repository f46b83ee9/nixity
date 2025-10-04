{
  config,
  ...
}:
{
  services.nginx.enable = true;

  services.nginx.virtualHosts."key.vfd.ovh" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations."/metrics" = {
      proxyPass = "http://127.0.0.1:${toString config.services.pocket-id.settings.OTEL_EXPORTER_PROMETHEUS_PORT}";
    };

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.pocket-id.settings.PORT}";
      extraConfig = ''
        proxy_busy_buffers_size   512k;
        proxy_buffers   4 512k;
        proxy_buffer_size   256k;
      '';
    };

    extraConfig = ''
      access_log /var/log/nginx/key.vfd.ovh.access.log;
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
