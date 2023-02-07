{ config, pkgs, ... }:

{
  programs.fish.enable = true;

  users = {
    users.luo = {
      isNormalUser = true;
      description = "Luo";
      extraGroups = [ "networkmanager" "wheel" "video" ];
      useDefaultShell = true;
    };
    defaultUserShell = pkgs.fish;
  };
}
