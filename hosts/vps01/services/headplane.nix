{
  lib,
  pkgs,
  config,
  ...
}:
{
  sops.secrets."headplane/cookie_secret" = {
    owner = config.services.headscale.user;
    group = config.services.headscale.group;
  };

  sops.secrets."headplane/pre_authkey" = {
    owner = config.services.headscale.user;
    group = config.services.headscale.group;
  };

  sops.secrets."headplane/headscale_api_key" = {
    owner = config.services.headscale.user;
    group = config.services.headscale.group;
  };

  services.headplane = {
    enable = true;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 3000;
        cookie_secret_path = config.sops.secrets."headplane/cookie_secret".path;
        cookie_secure = true;
      };

      integration = {
        agent = {
          enabled = true;
          pre_authkey_path = config.sops.secrets."headplane/pre_authkey".path;
        };

        proc = {
          enabled = true;
        };
      };

      headscale = {
        url = config.services.headscale.settings.server_url;

        config_path = "${(pkgs.formats.yaml { }).generate "headscale.yml" (
          lib.recursiveUpdate config.services.headscale.settings {
            tls_cert_path = "/dev/null";
            tls_key_path = "/dev/null";
            policy.path = "/dev/null";
          }
        )}";

        config_strict = true;
      };

      oidc = {
        issuer = "https://key.vfd.ovh";
        client_id = "fac68529-32af-47f6-94ed-6f584fa0ebb7";
        client_secret_path = config.sops.secrets."headscale/oidc_client_secret".path;
        disable_api_key_login = false;
        headscale_api_key_path = config.sops.secrets."headplane/headscale_api_key".path;
        redirect_uri = "https://headscale.vfd.ovh/admin/oidc/callback";
      };
    };
  };
}
