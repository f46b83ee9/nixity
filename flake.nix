{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, disko, sops-nix, ... }:
    {
      nixosConfigurations.vps01 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/vps01/configuration.nix
        ];
      };

      nixosConfigurations.rpi01 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          sops-nix.nixosModules.sops
          ./hosts/rpi01/configuration.nix
        ];
      };
    };
}
