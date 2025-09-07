{
  config,
  pkgs,
  ...
}:
let
  base_domain = "vfd.ovh";
  server_url = "key.${base_domain}";
in
{
  sops.secrets."pocketid/encryption_key" = {
    owner = config.services.pocket-id.user;
    inherit (config.services.pocket-id) group;
  };

  sops.secrets."smtp/password" = {
    sopsFile = ../../../secrets/common/smtp.yaml;

    owner = config.services.pocket-id.user;
    inherit (config.services.pocket-id) group;
  };

  services.pocket-id = {
    enable = true;

    settings = {
      HOST = "127.0.0.1";
      PORT = 8080;

      APP_URL = "https://${server_url}";
      TRUST_PROXY = true;

      METRICS_ENABLED = true;
      OTEL_METRICS_EXPORTER = "prometheus";
      OTEL_EXPORTER_PROMETHEUS_HOST = "127.0.0.1";
      OTEL_EXPORTER_PROMETHEUS_PORT = 9464;

      UI_CONFIG_DISABLED = true;

      EMAILS_VERIFIED = true;

      SMTP_HOST = "smtp-relay.brevo.com";
      SMTP_PORT = 587;
      SMTP_FROM = "no-reply@${base_domain}";
      SMTP_USER = "95f851001@smtp-brevo.com";
      SMTP_PASSWORD_FILE = config.sops.secrets."smtp/password".path;
      SMTP_TLS = "starttls";

      EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = true;
      EMAIL_API_KEY_EXPIRATION_ENABLED = true;
    };
  };

  services.nginx.virtualHosts."${server_url}" = {
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
      access_log /var/log/nginx/${server_url}.access.log;
    '';
  };

  sops.secrets."cloudflare/env" = {
    sopsFile = ../../../secrets/common/cloudflare.yaml;
  };

  security.acme.acceptTerms = true;
  security.acme.defaults = {
      email = "me@${base_domain}";

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
