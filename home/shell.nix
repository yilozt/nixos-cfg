{ ... }:

let alias = {
  nixsw = "sudo nixos-rebuild switch --flake '.#'";
  ls = "exa";
  flib = "pkg-config --list-all|grep";
  phone = "scrcpy -Sm 1024";
};
in

{
  programs.fish.shellAliases = alias;
  programs.fish.enable = true;
}
