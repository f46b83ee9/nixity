{ config, ... }:
{
  sops.secrets."cloudflared/tunnel_json" = { };

  services.cloudflared.enable = true;

  services.cloudflared.tunnels."d8c2a16d-c6fa-447e-8fd2-537b46152483" = {
    credentialsFile = config.sops.secrets."cloudflared/tunnel_json".path;
    default = "http_status:404";
    ingress = {
      "id.vfd.ovh" = "http://localhost:8080";
    };
  };
}
