# Extra enabled / custom services

{ stdenv, pkgs, ... }:

let
  # Create custom packages for v2raya from github releases
  v2raya_pkg = pkgs.stdenv.mkDerivation {
    name = "v2raya";
    src = builtins.fetchurl {
      url = "https://github.com/v2rayA/v2rayA/releases/download/v1.5.9.1698.1/v2raya_linux_x64_1.5.9.1698.1";
      sha256 = "sha256:114d6jfhi6b4lwlq1l5nj4041nc1w5c1s407js6cdhi13sa4blzz";
    };
    buildInputs = with pkgs; [ v2ray iptables bash ];
    nativeBuildInputs = with pkgs; [ makeWrapper ];
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      install -m 755 $src $out/bin/.v2raya
    '';
    postFixup = with pkgs; ''
      # Wrap v2raya binary with currect $PATH
      makeWrapper $out/bin/.v2raya $out/bin/v2raya \
        --suffix PATH : ${lib.makeBinPath [ v2ray iptables bash ]}
    '';
  };

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

  # A systemd services to launch v2raya 
  # ref: https://aur.archlinux.org/cgit/aur.git/tree/v2raya.service?h=v2raya-bin
  v2raya = simple_service {
    script = "${v2raya_pkg}/bin/v2raya";
    after = [ "network.target" "nss-lookup.target" "iptables.service" "ip6tables.service" ];
    wants = [ "network.target" ];
  };

in
{
  services.touchegg.enable = true;

  systemd.services = { inherit setup_keycode_map v2raya; };
}
