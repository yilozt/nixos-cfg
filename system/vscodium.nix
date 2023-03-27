{ pkgs, ... }:

let
  pkgs_prog = with pkgs; with vscode-extensions; {
    go = {
      pkg = [ go gotools gdb delve ];
      vscode_ext = [ golang.go ];
    };
    cpp = {
      pkg = [ gdb lldb valgrind pkg-config cmake gnumake ];
      vscode_ext = [ ms-vscode.cpptools ms-vscode.cmake-tools ];
    };
    rust = {
      pkg = [ rustup gcc lldb pkg-config cmake gnumake fontconfig ];
      vscode_ext = [ rust-lang.rust-analyzer ];
    };
  };
  enable_progs = [ "cpp" "rust" ];
  pkglst = builtins.concatLists (builtins.map (p: pkgs_prog."${p}".pkg) enable_progs);
  vscode_ext_lst = builtins.concatLists (builtins.map (p: pkgs_prog."${p}".vscode_ext) enable_progs);
in
{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          jock.svg
          jnoortheen.nix-ide
          github.github-vscode-theme
          james-yu.latex-workshop
          # ms-python.python
          twxs.cmake
          vscodevim.vim
          ms-vscode-remote.remote-ssh
          ms-ceintl.vscode-language-pack-zh-hans
          eamodio.gitlens
          mhutchie.git-graph
          streetsidesoftware.code-spell-checker
          usernamehw.errorlens
          WakaTime.vscode-wakatime
          ms-dotnettools.csharp # C Sharp
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "shader";
            publisher = "slevesque";
            version = "1.1.5";
            sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
          }
          {
            name = "mono-debug";
            publisher = "ms-vscode";
            version = "0.16.3";
            sha256 = "sha256-6IU8aP4FQVbEMZAgssGiyqM+PAbwipxou5Wk3Q2mjZg=";
          }
          {
            name = "debug";
            publisher = "webfreak";
            version = "0.26.0";
            sha256 = "sha256-ZFrgsycm7/OYTN2sD3RGJG+yu0hTvADkHK1Gopm0XWc=";
          }
          {
            name = "veriloghdl";
            publisher = "mshr-h";
            version = "1.10.0";
            sha256 = "sha256-OXbl1Dloo1kFpApF830NkYyCXV3mAvF86MpfHimlstE=";
          }
          {
            name = "language-x86-64-assembly";
            publisher = "13xforever";
            version = "3.0.0";
            sha256 = "sha256-wIsY6Fuhs676EH8rSz4fTHemVhOe5Se9SY3Q9iAqr1M=";
          }
          {
            name = "volar";
            publisher = "vue";
            version = "1.2.0";
            sha256 = "sha256-rIvZEl2KxT8m7lFQZ3lIRzksmxIx2+tKFR7v2HCj/XM=";
          }
        ] ++ vscode_ext_lst;
    })
  ] ++ pkglst;
}
