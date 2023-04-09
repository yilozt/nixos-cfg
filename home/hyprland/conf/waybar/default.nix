{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };
  xdg.configFile = {
    "waybar/config.jsonc".source = ./config.jsonc;
    "waybar/scripts" = { source = ./scripts; recursive = true; };
    "waybar/style.css".source = ./style.css;
  };
  home.packages = with pkgs; [
    pamixer
  ];
}
