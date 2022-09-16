{
  description = "Yi's NixOS configurations, power by flakes & home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.luo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.luo = nixpkgs.lib.mkMerge [
              ./home
            ];
          }
        ];
    };
  };
}
