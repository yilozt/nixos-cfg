{config, pkgs,... }:

{
  programs.fish.enable = true;
  
  users = {
    users.luo = {
      isNormalUser = true;
      description = "Luo";
      extraGroups = [ "networkmanager" "wheel" "docker" ];
      packages = with pkgs; [
        firefox
        tdesktop
      ];
      useDefaultShell = true;
    };
    defaultUserShell = pkgs.fish;
  };
}
