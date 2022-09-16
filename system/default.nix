{ lib, pkgs, ... }: {
  imports = [
    ./base.nix
    ./boot.nix
    ./desktop.nix
    ./gpu.nix
    ./i18n.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
  ];
}