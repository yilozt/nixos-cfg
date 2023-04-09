{ pkgs, ... }: {
  programs.wezterm.enable = true;
  xdg.configFile = {
    "wezterm/colors" = { source = ./colors; recursive = true; };
    "wezterm/lua" = { source = ./lua; recursive = true; };
    "wezterm/wezterm.lua" = { source = ./wezterm.lua; recursive = true; };
  };
}
