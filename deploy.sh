#!/usr/bin/env bash

# Create a temporary directory
temp=$(mktemp -d)

# Function to cleanup temporary directory on exit
cleanup() {
    rm -rf "$temp"
}
trap cleanup EXIT

# Create the directory where sshd expects to find the host keys
install -d -m755 "$temp/etc/ssh"
sops decrypt secrets/vps01/secrets.yaml | yq '.ssh.ssh_host_ed25519_key' > "$temp/etc/ssh/ssh_host_ed25519_key"

# Set the correct permissions so sshd will accept the key
chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"

# Install NixOS to the host system with our secrets
nix run github:nix-community/nixos-anywhere -- --extra-files "$temp" --flake '.#vps01' --target-host root@vps01.vfd.ovh
