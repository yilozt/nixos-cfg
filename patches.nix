{ nixpkgs, system, patches ? [ ] }:

let origPkgs = nixpkgs.legacyPackages."${system}";
in if (builtins.length patches != 0) then
  import (origPkgs.applyPatches {
    name = "nixpkgs-patched";
    src = nixpkgs;
    patches = map origPkgs.applyPatches patches;
  } + "/nixos/lib/eval-config.nix")
else
  nixpkgs.lib.nixosSystem

