{ ... }:

{
  imports = [
    ./kvm.nix
  ];

  virtualisation = {
    lxd.enable = true;
    waydroid.enable = true;
    # docker.enable = true;
  };
}
