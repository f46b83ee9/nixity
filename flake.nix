{
  description = "Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-rosetta-builder.url = "github:cpick/nix-rosetta-builder";
    nix-rosetta-builder.inputs.nixpkgs.follows = "nixpkgs";

    headplane.url = "github:tale/headplane/next";
    headplane.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      headplane,
      disko,
      sops-nix,
      nix-darwin, 
      nix-rosetta-builder,
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
          headplane.nixosModules.headplane
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
          sops-nix.nixosModules.sops
          ./hosts/rpi01/configuration.nix
        ];
      };

      darwinConfigurations."Dimitris-MacBook-Air" = nix-darwin.lib.darwinSystem {
        inherit specialArgs;

        modules = [ 
          nix-rosetta-builder.darwinModules.default
          ./hosts/mba/configuration.nix
        ];
      };
    };
}
