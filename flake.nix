{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      sops-nix,
      ...
    }:
    let
      specialArgs = { inherit inputs; };
    in
    {
      nixosConfigurations.vps01 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/vps01/configuration.nix
        ];
      };

      nixosConfigurations.vps02 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/vps02/configuration.nix
        ];
      };

      nixosConfigurations.rpi01 = nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        system = "aarch64-linux";
        modules = [
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          ./hosts/rpi01/configuration.nix
        ];
      };
    };
}
