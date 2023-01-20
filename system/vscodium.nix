{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        github.github-vscode-theme
        ms-python.python
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        vscode-extensions.twxs.cmake
        ms-vscode-remote.remote-ssh
        golang.go
        ms-ceintl.vscode-language-pack-zh-hans
        eamodio.gitlens
        mhutchie.git-graph
        streetsidesoftware.code-spell-checker
        usernamehw.errorlens
        WakaTime.vscode-wakatime
        vscode-extensions.ms-dotnettools.csharp # C Sharp
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
      ];
    })
  ];
}
