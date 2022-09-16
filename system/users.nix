{config, pkgs,... }:

{
  programs.fish.enable = true;
  
  users = {
    users.luo = {
      isNormalUser = true;
      description = "Luo";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      useDefaultShell = true;
    };
    defaultUserShell = pkgs.fish;
  };
}
