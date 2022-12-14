{
  description = "NixOS configurations, power by flakes & home-manager";

  inputs = {
    # lock commit hash to nixos-unstable
    nixpkgs.url = "nixpkgs/2e193264db568a42b342e4b914dc314383a6194c";
    home-manager.url = "github:nix-community/home-manager";

    #nur.url = "github:nix-community/NUR";
    #.url = "github:nixos-cn/flakes";
    #nur-pkgs.url = github:ocfox/nur-pkgs;

    yi-pkg.url = "github:yilozt/nurpkg";
  };

  outputs = inputs @ { self, home-manager, ... }:
    let
      # Apply remote patches to nixpkgs
      # ref; https://github.com/NixOS/nixpkgs/pull/142273#issuecomment-948225922
      remoteNixpkgsPatches = [];
      system = "x86_64-linux";
      originPkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      nixpkgs = originPkgs.applyPatches {
        name = "nixpkgs-patched";
        src = inputs.nixpkgs;
        patches = map originPkgs.fetchpatch remoteNixpkgsPatches;
      };
      # nixosSystem = import (nixpkgs + "/nixos/lib/eval-config.nix");
      # Uncomment to use a Nixpkgs without remoteNixpkgsPatches
      nixosSystem = inputs.nixpkgs.lib.nixosSystem;
    in
    {

      # Used with `nixos-rebuild --flake .#<hostname>`
      # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
      nixosConfigurations.luo = nixosSystem {
        inherit system;
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
              home-manager.users.luo = originPkgs.lib.mkMerge [
                ./home
              ];
            }

            {
              imports = [
                # Services for v2raya
                inputs.yi-pkg.nixosModules.v2raya
              ];

              nixpkgs.overlays = [
                # Install packages from nur:
                # add nur.repo.<username>.<packagename> to packages list 
                # nur.overlay

                # nixos-cn.<pkgname>
                # nixos-cn.overlay

                (final: prev: with inputs; {
                  yi-pkg = yi-pkg.packages."${prev.system}";
                })
              ];

              # ?????? nixos-cn ??? binary cache
              nix.settings.substituters = [
                # "https://nixos-cn.cachix.org"
                # "https://mirror.sjtu.edu.cn/nix-channels/store"
                # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
                "https://mirrors.ustc.edu.cn/nix-channels/store"
              ];
              nix.settings.trusted-public-keys = [
                # "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
              ];
            }
          ];
      };
    };
}
