{ ... }:

{
  imports = [
    ./gnome.nix
  ];

  # Override xwayland to enable Hidpi patch
  # nixpkgs.config.packageOverrides = pkgs:
  #   {
  #     xwayland = pkgs.xwayland.overrideAttrs (old: {
  #       patches =
  #         (old.patches or [ ])
  #         ++ [
  #           (pkgs.fetchpatch {
  #             url = "https://raw.githubusercontent.com/hyprwm/Hyprland/c0a7dffcdc6cb04e5dd7dacf04681f9d2b361b97/nix/xwayland-hidpi.patch";
  #             sha256 = "sha256-6YMZDNJp9gZCfIg9YhsvMfSnbUdj6i537semRSkdWiw=";
  #           })
  #           (pkgs.fetchpatch {
  #             url = "https://raw.githubusercontent.com/hyprwm/Hyprland/c0a7dffcdc6cb04e5dd7dacf04681f9d2b361b97/nix/xwayland-vsync.patch";
  #             sha256 = "sha256-VjquNMHr+7oMvnFQJ0G0whk1/253lZK5oeyLPamitOw=";
  #           })
  #         ];
  #     });

  #     gnome = pkgs.gnome //{
  #       mutter = pkgs.gnome.mutter.overrideAttrs (old: {
  #         src = pkgs.fetchgit {
  #           url = "https://salsa.debian.org/gnome-team/mutter.git";
  #           rev = "ubuntu/42.3-0ubuntu1";
  #         };
  #       });
  #     };
  #   };
}
