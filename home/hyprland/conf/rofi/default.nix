{ pkgs, ... }: {
  programs.rofi.enable = true;

  xdg.configFile = {
    "rofi/global" = { source = ./global; recursive = true; };
    "rofi/powermenu" = { source = ./powermenu; recursive = true; };
    "rofi/scripts" = { source = ./scripts; recursive = true; };
  };

  home.packages = with pkgs; [
    betterlockscreen
  ];
}
