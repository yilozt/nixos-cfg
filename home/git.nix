{ ... }:

{
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;

    signing = {
      key = "CC6DCC0EF4602172";
      signByDefault = true;
    };

    aliases = {
      a = "add -p";
      co = "checkout";
      cob = "checkout -b";
      f = "fetch -p";
      c = "commit";
      p = "push";
      bD = "branch -D";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      r = "restore";
      # reset
      soft = "reset --soft";
      hard = "reset --hard";
    };
  };
}
