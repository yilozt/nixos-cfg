{
  description = "NixOS configurations, power by flakes & home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nixos-cn = {
      url = "github:nixos-cn/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-pkgs = {
      url = github:ocfox/nur-pkgs;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    blackbox.url = "github:mitchmindtree/blackbox.nix";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, nixos-cn, ... }: {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.luo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules =
        [
          # System wide configuration
          ./configuration.nix

          # User configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.luo = nixpkgs.lib.mkMerge [
              ./home
            ];
          }

          {
            nixpkgs.overlays = [
              # Install packages from nur:
              # add nur.repo.<username>.<packagename> to packages list 
              nur.overlay

              # nixos-cn.<pkgname>
              nixos-cn.overlay

              (final: prev: {
                nur-pkgs = inputs.nur-pkgs.packages."${prev.system}";
              })

              (final: prev: {
                blackbox = inputs.blackbox.packages."${prev.system}";
              })
            ];

            # 使用 nixos-cn 的 binary cache
            nix.settings.substituters = [
              "https://nixos-cn.cachix.org"
            ];
            nix.settings.trusted-public-keys = [
              "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
            ];
          }
        ];
    };
  };
}
