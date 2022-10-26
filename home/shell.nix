{ ... }:

let alias = { };
in

{
  programs.fish.shellAliases = alias;
  programs.fish.enable = true;
}
