{
  config,
  pkgs,
  ...
}:
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

      APP_URL = "https://key.vfd.ovh";
      TRUST_PROXY = true;

      METRICS_ENABLED = true;
      OTEL_METRICS_EXPORTER = "prometheus";
      OTEL_EXPORTER_PROMETHEUS_HOST = "127.0.0.1";
      OTEL_EXPORTER_PROMETHEUS_PORT = 9464;

      UI_CONFIG_DISABLED = true;

      EMAILS_VERIFIED = true;

      SMTP_HOST = "smtp-relay.brevo.com";
      SMTP_PORT = 587;
      SMTP_FROM = "no-reply@vfd.ovh";
      SMTP_USER = "95f851001@smtp-brevo.com";
      SMTP_PASSWORD_FILE = config.sops.secrets."smtp/password".path;
      SMTP_TLS = "starttls";

      EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = true;
      EMAIL_API_KEY_EXPIRATION_ENABLED = true;
    };
  };
}
