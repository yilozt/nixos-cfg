{ pkgs, ... }:
{
  programs.wlogout.enable = true;
  xdg.configFile = {
    "wlogout/layout".source = ./layout;
    "wlogout/icons" = { source = ./icons; recursive = true; };
    "wlogout/style.css".source = ./style.css;
  };
}
