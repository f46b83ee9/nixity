{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/vps01/secrets.yaml;

  sops.secrets."wireguard/private_key" = { };

  sops.secrets."restic/repository_password" = { 
    sopsFile = ../../secrets/common/restic.yaml;
  };

  sops.secrets."restic/sftp_private_key" = { 
    sopsFile = ../../secrets/common/restic.yaml;
  };
}
