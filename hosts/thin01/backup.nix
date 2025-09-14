{ config, pkgs, ... }:
{
  sops.secrets."restic/repository_password" = {
    sopsFile = ../../secrets/common/restic.yaml;
  };

  sops.secrets."restic/sftp_private_key" = {
    sopsFile = ../../secrets/common/restic.yaml;
  };

  programs.ssh.knownHosts = {
    "192.168.10.251".publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPfDylt0E4ibkH5eS72HKgZPSvO/dIEWlHVSpFt7nDj";
  };

  services.restic.backups = {
    sftp = {
      initialize = true;

      paths = [
        "/var/lib/acme"
        "/var/lib/forgejo"
      ];

      repository = "sftp::/restic";
      passwordFile = config.sops.secrets."restic/repository_password".path;

      extraOptions = [
        "sftp.command='ssh restic@192.168.10.251 -i ${
          config.sops.secrets."restic/sftp_private_key".path
        } -s sftp'"
      ];

      timerConfig = {
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
}
