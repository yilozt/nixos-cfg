# GNOME desktop configrations

{ config, pkgs, ... }:

{
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # enable flatpak
  services.flatpak.enable = true;

  # Add a new session to launch gnome-shell with nvidia driver
  services.xserver.displayManager.session = [
    {
      manage = "desktop";
      name = "Gnome-Nvidia";
      start = ''
        export XDG_SESSION_TYPE=x11
        export GDK_BACKEND=x11
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        ${pkgs.gnome.gnome-session}/bin/gnome-session &
        waitPID=$!
        unset __NV_PRIME_RENDER_OFFLOAD
        unset __NV_PRIME_RENDER_OFFLOAD_PROVIDER
        unset __GLX_VENDOR_LIBRARY_NAME
        unset __VK_LAYER_NV_optimus
      '';
    }
  ];

  # Workaround for GNOME autologin:
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "luo";

  environment.gnome.excludePackages = with pkgs; [
    yelp
    simple-scan
    gnome-photos
    gnome.gnome-logs
    gnome.gnome-maps
    gnome.gnome-music
    gnome.gnome-contacts
    gnome.gnome-clocks
    gnome-tour
    gnome-console
    gnome-text-editor
    epiphany
    gnome.cheese
    gnome.nautilus # use nemo instead
  ];
  environment.systemPackages = with pkgs; [
    cinnamon.nemo
    gnome.gnome-terminal
    gnome.baobab
  ];
}
