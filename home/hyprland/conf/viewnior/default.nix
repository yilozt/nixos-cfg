{ pkgs, ... }: {
  home.packages = with pkgs; [ viewnior ];
  xdg.configFile."viewnior/accel_map".source = ./accel_map;
  xdg.configFile."viewnior/viewnior.conf".source = ./viewnior.conf;
}
