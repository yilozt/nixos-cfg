{
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = all@{ self, nixpkgs }: {

    # Used with `nixos-rebuild --flake .#<hostname>`
    # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
    nixosConfigurations.luo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./configuration.nix
        ];
    };
  };
}
