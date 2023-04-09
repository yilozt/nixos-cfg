{ pkgs, ... }:
let

  script = with pkgs; writeShellScriptBin "auto_start" ''
    #!/usr/bin/env bash
    sleep 1
    killall .xdg-desktop-portal-hyprland
    killall .xdg-desktop-portal-wlr
    killall .xdg-desktop-portal-gtk
    killall .xdg-desktop-portal
    ${libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1 &
    sleep 1
    ${xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
    ${xdg-desktop-portal-wlr}/libexec/xdg-desktop-portal-wlr &
    ${xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk &
    ${xdg-desktop-portal}/libexec/xdg-desktop-portal &
  '';
in
{

  home.packages = with pkgs;[
    killall
  ] ++ [ script ];
}
