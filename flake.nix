{
  description = "NixOS configuration for nixos-sir";

  inputs = {
    # You can pin nixpkgs to a specific branch or commit if desired
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Optionally include home-manager or other flakes
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-sir = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # Your system configuration file
        ./configuration.nix


        ## Integrate Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.tizzysaurus = import ./home.nix;
        }
      ];
    };
  };
}