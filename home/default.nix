{ pkgs, quartus, nixos_2205, ... }: {
  imports = [ ./shell.nix ./gnome.nix ./git.nix ];

  # Install home-manager package
  home.stateVersion = "22.11";
  gtk =
    let extra_cfg = { gtk-application-prefer-dark-theme = 0; };
    in {
      enable = true;
      theme = {
        name = "Sweet";
      };
      gtk3.extraConfig = extra_cfg;
      gtk4.extraConfig = extra_cfg;
      iconTheme = {
        name = "Tela-circle";
        package = pkgs.tela-circle-icon-theme;
      };
    };

  nixpkgs.config = { allowUnfree = true; };

  home.packages = with pkgs; [
    blackbox-terminal # A beautiful GTK4 terminal
    dfeet # Debug dbus sessions
    nixos_2205.goldendict # keep to NixOS because I want not to rebuild webkit-qt
    (lutris.override {
      lutris-unwrapped =
        lutris-unwrapped.override { wine = wineWowPackages.staging; };
    })
    feishu
    newsflash
    nix-index
    nixfmt
    okular
    peek
    qbittorrent
    scrcpy
    asymptote
    texlive.combined.scheme-full
    tdesktop
    thunderbird
    birdtray
    wget
    wpsoffice-cn
    xorg.libXcursor
    yi-pkg.system-monitoring-center
    vlc
    ubuntu_font_family
    quartus.quartus-prime-lite
    microsoft-edge
    nur.repos.linyinfeng.wemeet
  ];
}
