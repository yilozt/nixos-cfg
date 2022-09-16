{ pkgs, ... }:

{
  imports = [
    ./gnome.nix
  ];

  # Install home-manager package
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    firefox
    tdesktop
    dfeet
    nix-index
    nixfmt
    wget
    peek
  ];
}
