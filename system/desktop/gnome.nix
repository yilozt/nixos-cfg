# GNOME desktop configrations

{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # enable flatpak
  services.flatpak.enable = true;

  # Workaround for GNOME autologin:
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "luo";

  environment.gnome.excludePackages = with pkgs; [
    yelp
    simple-scan
    gnome-photos
    gnome.gnome-logs
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome-console
    gnome-text-editor
    epiphany
    gnome.cheese
    gnome.nautilus # use elementary-files instead
  ];
  environment.systemPackages = with pkgs; [
    pantheon.elementary-files
    gnome.gnome-terminal
  ];
}
