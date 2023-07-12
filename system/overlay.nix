{ pkgs, ... }:
(self: super:
{
  gnome = super.gnome.overrideScope' (gself: gsuper: {
    mutter = gsuper.mutter.overrideAttrs (oldAttrs: rec {
      version = "44.3";
      src = pkgs.fetchurl {
        url = "mirror://gnome/sources/mutter/${pkgs.lib.versions.major version}/${oldAttrs.pname}-${version}.tar.xz";
        sha256 = "sha256-GFy+vyFQ0+RQVQ43G9sTqLTbCWl4sU+ZUh6WbqzHBVE=";
      };
      patches = [
        # Fix build with separate sysprof.
        # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2572
        (pkgs.fetchpatch {
          url = let scaling_commit = "82e4a2c864e5e238bd03b1f4ef05f737915dac8c"; in
            "https://salsa.debian.org/gnome-team/mutter/-/raw/${scaling_commit}/debian/patches/ubuntu/x11-Add-support-for-fractional-scaling-using-Randr.patch";
          sha256 = "sha256-GCtz87C1NgxenYE5nbxcIIxqNhutmdngscnlK10fRyQ=";
        })
      ];
    });
  });
})
