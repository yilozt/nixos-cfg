{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        jnoortheen.nix-ide
        github.github-vscode-theme
        ms-python.python
        ms-vscode.cpptools
        ms-vscode-remote.remote-ssh
        golang.go
        ms-ceintl.vscode-language-pack-zh-hans
        eamodio.gitlens
        mhutchie.git-graph
        streetsidesoftware.code-spell-checker
        usernamehw.errorlens
        WakaTime.vscode-wakatime
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "shader";
        publisher = "slevesque";
        version = "1.1.5";
        sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
      }
    ];
    })
  ];
}
