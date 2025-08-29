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
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSWp44dXcZrHV/lbS6gYDfWAnB4WAOwWGE0XvuHfX3y"
  ];
}
