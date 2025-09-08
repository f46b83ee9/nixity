{ inputs, pkgs, ... }: {
    environment.systemPackages =
    [   pkgs.vim
        pkgs.sops
        pkgs.yq
        pkgs.caligula
        pkgs.zstd
        pkgs.qemu
        pkgs.k9s
    ];

    security.pam.services.sudo_local.touchIdAuth = true;

    nix.settings.experimental-features = "nix-command flakes";

    nix-rosetta-builder.onDemand = true;

    system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    system.stateVersion = 6;

    nixpkgs.hostPlatform = "aarch64-darwin";
}