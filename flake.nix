{
  description = "NixOS configurations, power by flakes & home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "nixpkgs/5a350a8f31bb7ef0c6e79aea3795a890cf7743d4";
    quartus.url = "nixpkgs/8065069c54c21c7cc8d6aed7726c5d5acf21b666";
    nixos_2205.url = "nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nur.url = "github:nix-community/NUR";
    yi-pkg.url = "github:yilozt/nurpkg";
  };

  outputs =
    inputs@{ self, yi-pkg, home-manager, nur, nixpkgs, quartus, nixos_2205 }:
    let

      system = "x86_64-linux";

      # Extra args
      # Those args will be pass to ./configuration.nix

      extra_args = {
        quartus = import quartus {
          inherit system;
          config.allowUnfree = true;
        };
        nixos_2205 = import nixos_2205 { inherit system; };
      };
    in {

      # Used with `nixos-rebuild --flake .#<hostname>` to rebuild system.
      # nixosConfigurations."<hostname>".config.system.build.toplevel
      # must be a derivation

      nixosConfigurations.luo = import ./patches.nix {
        inherit system;
        inherit nixpkgs;

        # Apply remote patches to nixpkgs
        # Ref: https://github.com/NixOS/nixpkgs/pull/142273#issuecomment-948225922

        patches = [ ];
      } {
        inherit system;

        # Pass extra arguments to configurations

        specialArgs = extra_args;
        modules = [

          # System wide configuration

          ./configuration.nix

          # User configuration

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.luo = nixpkgs.lib.mkMerge [ ./home ];
            home-manager.extraSpecialArgs = extra_args;
          }

          {
            nixpkgs.overlays = [

              # Install packages from nur:
              # add nur.repo.<username>.<packagename> to packages list 

              nur.overlay

              (final: prev:
                with inputs; {
                  yi-pkg = yi-pkg.packages."${prev.system}";
                })
            ];

            nix.settings.substituters = [
              "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
              "https://mirrors.ustc.edu.cn/nix-channels/store"
              "https://mirror.sjtu.edu.cn/nix-channels/store"
            ];
          }
        ];
      };
    };
}
