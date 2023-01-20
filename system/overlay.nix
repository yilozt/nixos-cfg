{ pkgs, ... }:
(self: super:
  {
    gnome = super.gnome.overrideScope' (gself: gsuper: {
      mutter = gsuper.mutter.overrideAttrs (oldAttrs: rec {
        version = "43.2";
        src = pkgs.fetchurl {
          url = "mirror://gnome/sources/mutter/${pkgs.lib.versions.major version}/${oldAttrs.pname}-${version}.tar.xz";
          sha256 = "sha256-/S63B63DM8wnevhoXlzzkTXhxNeYofnQXojkU9w+u4Q=";
        };
        patches = [
          # Fix build with separate sysprof.
          # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2572
          (pkgs.fetchpatch {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/commit/285a5a4d54ca83b136b787ce5ebf1d774f9499d5.patch";
            sha256 = "/npUE3idMSTVlFptsDpZmGWjZ/d2gqruVlJKq4eF4xU=";
          })
        ];
      });

      gnome-shell = gsuper.gnome-shell.overrideAttrs (oldAttrs: rec {
        version = "43.2";
        src = pkgs.fetchurl {
          url = "mirror://gnome/sources/gnome-shell/${pkgs.lib.versions.major version}/${oldAttrs.pname}-${version}.tar.xz";
          sha256 = "sha256-52/UvpNCQQ7p+9zday2Bxv8GDnyMxaDxyuanq6JdGGA=";
        };
      });
    });
  }
)
