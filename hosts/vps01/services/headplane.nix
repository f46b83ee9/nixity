{
  lib,
  config,
  pkgs,
  ...
}:
let
  format = pkgs.formats.yaml {};

  # A workaround generate a valid Headscale config accepted by Headplane when `config_strict == true`.
  settings = lib.recursiveUpdate config.services.headscale.settings {
    acme_email = "/dev/null";
    tls_cert_path = "/dev/null";
    tls_key_path = "/dev/null";
    policy.path = "/dev/null";
  };

  headscaleConfig = format.generate "headscale.yml" settings;
in
{
  sops.secrets."headplane/serverCookieSecret" = {
    owner = config.services.headplane.user;
    group = config.services.headplane.group;
  };
  
  sops.secrets."headplane/oidcHeadscaleApiKey" = {
    owner = config.services.headplane.user;
    group = config.services.headplane.group;
  };

  sops.secrets."headplane/oidcClientSecret" = {
    owner = config.services.headplane.user;
    group = config.services.headplane.group;
  };

  sops.secrets."headplane/integrationAgentPreAuthkeyPath" = {
    owner = config.services.headplane.user;
    group = config.services.headplane.group;
  };

  services.headplane = {
    enable = true;

    agent = {
      enable = false;
    };
    
    settings = {
      server = {
          host = "127.0.0.1";
          port = 3000;
          cookie_secret_path = config.sops.secrets."headplane/serverCookieSecret".path;
          cookie_secure = true;
      };

      headscale = {
          url = config.services.headscale.settings.server_url;
          config_path = "${headscaleConfig}";
      };

      integration.proc.enabled = true;

      oidc = {
          issuer = "https://key.vfd.ovh";
          client_id = "headplane";
          client_secret_path = config.sops.secrets."headplane/oidcClientSecret".path;

          disable_api_key_login = true;
          headscale_api_key_path = config.sops.secrets."headplane/oidcHeadscaleApiKey".path;
          
          redirect_uri = "https://headscale.vfd.ovh/admin/oidc/callback";
      };
    };
  };
}


