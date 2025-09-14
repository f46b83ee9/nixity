{
  lib,
  config,
  ...
}:
{
  sops.secrets."smtp/password" = {
    sopsFile = ../../../secrets/common/smtp.yaml;

    owner = config.services.forgejo.user;
    mode = "400";
  };

  sops.secrets."forgejo/admin_password" = {
    owner = config.services.forgejo.user;
    mode = "400";
  };

  services.forgejo = {
    enable = true;

    lfs.enable = true;

    settings = {
      server = {
        DOMAIN = "git.vfd.ovh";
        ROOT_URL = "https://git.vfd.ovh/";

        PROTOCOL = "http";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3000;
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = true;
      };

      oauth2_client.ENABLE_AUTO_REGISTRATION = true;
      oauth2_client.UPDATE_AVATAR = true;

      metrics = {
        ENABLED = true;
        ENABLED_ISSUE_BY_LABEL = true;
        ENABLED_ISSUE_BY_REPOSITORY = true;
      };

      security = {
        INSTALL_LOCK = true;
      };

      mailer = {
        ENABLED = true;
        SMTP_ADDR = "smtp-relay.brevo.com";
        SMTP_PORT = 587;
        PROTOCOL = "smtp+starttls";
        FROM = "no-reply@vfd.ovh";
        USER = "95f851001@smtp-brevo.com";
      };
    };

    mailerPasswordFile = config.sops.secrets."smtp/password".path;
  };

  systemd.services.forgejo.preStart =
    let
      adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
      pwd = config.sops.secrets."forgejo/admin_password";
      user = "administrator";
    in
    ''
      ${adminCmd} create --admin --email "root@vfd.ovh" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
      ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    '';
}
