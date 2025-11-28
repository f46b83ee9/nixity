{ config, pkgs, ... }:
{
  services.openssh = {
    enable = true;

    allowSFTP = false;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      PubkeyAuthentication = "yes";
      X11Forwarding = false;
    };

    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMT48CcI5L0mXR03igIaNFo+j0WnEAqvQlG+eeZqr9jP"
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIIjZi3NfZVxJZeRD7wR+iIiGCGRnlDbafukoF3Qf9MSGAAAACnNzaDpzZXJ2ZXI= ssh:server"
  ];

  services.opkssh = {
    enable = true;

    providers = {
      pocket-id = {
        issuer = "https://key.vfd.ovh";
        clientId = "fd8c75a3-664c-46d8-b3d7-bf20b81cd817";
        lifetime = "oidc";
      };
    };

    authorizations = [
      {
        user = "root";
        principal = "oidc:groups:ssh_administrators";
        inherit (config.services.opkssh.providers.pocket-id) issuer;
      }
    ];
  };
}
