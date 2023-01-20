# Extra enabled / custom services

{ stdenv, pkgs, ... }:

let
  # A simple function to create systemd services
  simple_service = { ... } @ service: {
    serviceConfig = {
      Type = "simple";
    };
    enable = true;
    wantedBy = [ "multi-user.target" ];
  } // service;

  # A systemd services to map keys
  # I need this because my 'w' key is broken :(
  # it will use F2 instead of 'w' key.
  # Ref: https://wiki.archlinux.org/title/Map_scancodes_to_keycodes#Using_setkeycodes
  setup_keycode_map = simple_service {
    script = "${pkgs.kbd}/bin/setkeycodes 3c 17";
  };

in
{
  services.v2raya.enable = true;
  services.touchegg.enable = true;

  systemd.services = { inherit setup_keycode_map; };
}
