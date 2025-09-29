{
  config,
  ...
}:
{
  services.nginx.enable = true;

  services.nginx.virtualHosts."git.vfd.ovh" = {
    forceSSL = true;
    enableACME = true;
    acmeRoot = null;

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.forgejo.settings.server.HTTP_PORT}";
      extraConfig = ''
        client_max_body_size 512M;
      '';
    };

    extraConfig = ''
      access_log /var/log/nginx/git.vfd.ovh.access.log;
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
