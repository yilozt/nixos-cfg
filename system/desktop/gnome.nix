# GNOME desktop configrations

{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # enable flatpak
  services.flatpak.enable = true;

  # Workaround for GNOME autologin:
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "luo";

  environment.gnome.excludePackages = with pkgs; [
    yelp
    simple-scan
    gnome-photos
    gnome.gnome-logs
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome-tour
    gnome-console
    gnome-text-editor
    epiphany
    gnome.cheese
    gnome.nautilus # use nemo instead
    gnome.geary # use thunderbird instead
  ];
  environment.systemPackages = with pkgs; [
    cinnamon.nemo
    gnome.gnome-terminal
    gnome.baobab
    gnome.adwaita-icon-theme
  ];

  # Style of qt
  qt5.style = "gtk2";
  qt5.platformTheme = "qt5ct";
  programs.xwayland.enable = true;
}
