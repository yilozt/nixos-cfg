{ config, lib, pkgs, ... }:

{
  nix.readOnlyStore = false;
  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };

  time.timeZone = "Asia/Shanghai";

  # hostname.
  networking.hostName = "luo";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "cn";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  services.jack.alsa.enable = true;
  services.jack.alsa.support32Bit = true;
  security.rtkit.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;
  hardware.steam-hardware.enable = true;

  # gnupg
  programs.gnupg.agent.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    rnix-lsp
    gnome.dconf-editor
    gnome.gnome-tweaks
    git
    exa
    bat
    xorg.xhost
    compsize
  ];

  # Enable nix command
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # nix settings
  nix.settings.stalled-download-timeout = 10;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Shell Alias
  environment.shellAliases = {
    rbnix = "sudo nixos-rebuild switch --flake '.#' -L";
    ls = "exa";
    cat = "bat";
    flib = "pkg-config --list-all|grep";
    phone = "scrcpy -Smw 1024";

    # Different development environment
    rustdev = "nix-shell -p rustup gcc lldb --run 'codium -n'";
    godev = "nix-shell -p go gotools gdb delve --run 'codium -n'";
    cppdev = "nix-shell -p stdenv gdb lldb valgrind --run 'codium -n'";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
