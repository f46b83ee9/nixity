{
  config,
  pkgs,
  ...
}:
let
  format = pkgs.formats.yaml {};
  headscaleConfig = format.generate "headscale.yml" config.services.headscale.settings;
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
      enable = true;
      settings = {
        pre_authkey_path = config.sops.secrets."headplane/integrationAgentPreAuthkeyPath".path;
      };
    };
    
    settings = {
      server = {
          host = "127.0.0.1";
          port = 3000;
          cookie_secret_path = config.sops.secrets."headplane/serverCookieSecret".path;
      };

      headscale = {
          url = config.services.headscale.settings.server_url;
          config_path = "${headscaleConfig}";
      };

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


