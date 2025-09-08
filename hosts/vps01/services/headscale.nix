{
  config,
  pkgs,
  ...
}:
{
  sops.secrets."headscale/oidc_client_secret" = {
    owner = config.services.headscale.user;
    group = config.services.headscale.group;
  };

  services.headscale = {
    enable = true;

    address = "127.0.0.1";
    port = 8080;

    settings.headscale.config_path = config.services.headplane.settings.headscale.config_path;

    settings = {
      server_url = "https://headscale.vfd.ovh";

      grpc_listen_addr = "127.0.0.1:50443";
      grpc_allow_insecure = true;

      metrics_listen_addr = "127.0.0.1:9090";

      oidc = {
        issuer = "https://key.vfd.ovh";
        client_id = "fac68529-32af-47f6-94ed-6f584fa0ebb7";
        client_secret_path = config.sops.secrets."headscale/oidc_client_secret".path;

        scope = [
          "openid"
          "profile"
          "email"
          "groups"
        ];

        pkce = {
          enabled = true;
          method = "S256";
        };
      };

      dns = {
        magic_dns = true;
        base_domain = "tailnet.vfd.ovh";
      };

      tls_cert_path = "/dev/null";
      tls_key_path = "/dev/null";
      policy.path = "/dev/null";
    };
  };

  networking.firewall.allowedTCPPorts = [
    3478 # STUN Derp
  ];
}
