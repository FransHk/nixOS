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
    # Define local names
    let
      system = "x86_64-linux";
      user = "fransh";

      # This builds the mkHost function. It will accept
      # the 'host' parameter (provided by the caller in 'in' below)
      # e.g. '#laptop' and build a nixosSystem based on that.
      mkHost = host: nixpkgs.lib.nixosSystem {
        inherit system; # shorthand for system = system (defined above)
        specialArgs = { inherit user; };
        modules = [
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

    # The 'in' inputs to this output function that builds
    # on the locals defined above.
    in {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop = mkHost "laptop";
      };
    };
}
