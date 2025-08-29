{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.defaultSopsFile = ../../secrets/vps01/secrets.yaml;

  sops.secrets."wireguard/private_key" = { };
}
