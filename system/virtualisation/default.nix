{ pkgs, ... }:

{
  imports = [ ./kvm.nix ];

  virtualisation = {
    lxd.enable = true;
    waydroid.enable = true;
    # virtualbox.host.enable = true;
    # docker.enable = true;
  };
  # users.extraGroups.vboxusers.members = [ "luo" ];
}
