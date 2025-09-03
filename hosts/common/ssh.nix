{ config, pkgs, ... }:
{
  services.openssh.enable = true;

  services.openssh = {
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
  ];
}
