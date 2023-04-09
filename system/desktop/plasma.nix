{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.plasma5.mobile.enable = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    oxygen
    khelpcenter
    konsole
    print-manager
  ];

  environment.systemPackages = with pkgs; [
    latte-dock
  ];
}
