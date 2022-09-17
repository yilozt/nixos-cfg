{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./gnome.nix
    ./git.nix
  ];

  # Install home-manager package
  programs.home-manager.enable = true;
  home.stateVersion = "22.05";

  home.packages = with pkgs; [
    firefox
    tdesktop
    dfeet     # Debug dbus sessions
    nix-index
    nixfmt
    wget
    peek

    nixos-cn.wechat-uos
    nur.repos.linyinfeng.wemeet
    # nur-pkgs.gtk-qq
    # (nur.repos.xddxdd.wine-wechat.override {
    #   # info：update sha256 if got error
    #   sha256 = "sha256-E0ZGFVp9h42G3iMzJ26P7WiASSgRdgnTHUTSRouFQYw=";
    # })
  ];
}
