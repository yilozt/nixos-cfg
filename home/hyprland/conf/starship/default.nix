{ pkgs, ... }: {
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = true;
  xdg.configFile."starship.toml".source = ./starship.toml;
}
