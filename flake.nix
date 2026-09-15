{
  description = "Fransh's small NixOS desktop and laptop setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      user = "fransh";
      mkHost = host: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit user; };
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    in {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop = mkHost "laptop";
      };
    };
}
