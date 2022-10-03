{ config, lib, pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  # mirror
  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    # "https://mirrors.ustc.edu.cn/nix-channels/store"
  ];

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
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    rnix-lsp
    vscodium
    gnome.dconf-editor
    gnome.gnome-tweaks
    git
    exa
    xorg.xhost

    steamPackages.steam-runtime
  ];

  # Enable nix command
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
