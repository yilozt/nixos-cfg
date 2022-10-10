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
  gtk = let extra_cfg = { gtk-application-prefer-dark-theme = 1; }; in
    {
      enable = true;
      theme = {
        package = pkgs.yi-pkg.colloid-gtk-theme;
        name = "Colloid-Dark-Compact-Nord";
      };
      gtk3.extraConfig = extra_cfg;
      gtk4.extraConfig = extra_cfg;
      iconTheme = {
        name = "Tela-circle";
        package = pkgs.tela-circle-icon-theme;
      };
    };

  home.packages = with pkgs; [
    firefox-bin
    tdesktop
    dfeet # Debug dbus sessions
    nix-index
    nixfmt
    wget
    peek
    rustup
    gcc
    goldendict
    qbittorrent

    # A beautiful GTK4 terminal
    blackbox.blackbox

    # (wpsoffice.override { useChineseVersion = true; })
    wpsoffice-cn
    (lutris.override {
      lutris-unwrapped = lutris-unwrapped.override {
        wine = wineWowPackages.staging;
      };
    })
    mangohud
    xorg.libXcursor
  ];
}
