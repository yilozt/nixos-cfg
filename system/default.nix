{ lib, pkgs, ... }: {
  nixpkgs.overlays = [
    # (import ./overlay.nix { inherit pkgs; })
  ];
  imports = [
    ./base.nix
    ./boot.nix
#    ./desktop
    ./gpu.nix
    ./i18n.nix
    ./services.nix
    ./users.nix
    ./virtualisation
    ./vscodium.nix
  ];
}
