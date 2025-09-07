{ config, ... }:
{

  # https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
  boot.kernel.sysctl."net.core.wmem_max" = 7500000;
  boot.kernel.sysctl."net.core.rmem_max" = 7500000;

  sops.secrets."cloudflared/tunnel_json" = { };

  services.cloudflared.enable = true;

  services.cloudflared.tunnels."d8c2a16d-c6fa-447e-8fd2-537b46152483" = {
    credentialsFile = config.sops.secrets."cloudflared/tunnel_json".path;

    originRequest.disableChunkedEncoding = true;

    default = "http_status:404";
    ingress = {
      "id.vfd.ovh" = "http://localhost:8080";
    };
  };
}
