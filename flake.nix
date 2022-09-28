{
  description = "NixOS configurations, power by flakes & home-manager";

  inputs = {
    nixpkgs.url = "nixpkgs/gnome";

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

    yi-pkg.url = "github:yilozt/nurpkg";

    blackbox.url = "github:mitchmindtree/blackbox.nix";
  };

  outputs = inputs @ { self, home-manager, nur, nixos-cn, ... }:
    let
      # Apply remote patches to nixpkgs
      # ref; https://github.com/NixOS/nixpkgs/pull/142273#issuecomment-948225922
      remoteNixpkgsPatches = [
        {
          meta.description = "[test] GNOME 42 → 43";
          url = "https://github.com/NixOS/nixpkgs/pull/182618.diff";
          sha256 = "sha256-2QB5q68GPs1IXADMAOH7Cm8u2IYM+IeSm2dHATSdXeY=";
        }
      ];
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
                nur.overlay

                # nixos-cn.<pkgname>
                nixos-cn.overlay

                (final: prev: with inputs; {
                  nur-pkgs = nur-pkgs.packages."${prev.system}";
                  blackbox = blackbox.packages."${prev.system}";
                  yi-pkg = yi-pkg.packages."${prev.system}";
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
