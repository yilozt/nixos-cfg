{ pkgs, config, ... }: {
  imports = [ ./scripts ./conf ];

  # -----
  # Fonts
  # -----

  fonts = {
    fontconfig.enable = true;
  };

  home.packages = with pkgs; [
    # wlsunset
    swaybg
    hyprpicker
    wl-clipboard
    wf-recorder
    python3
    pciutils
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    (callPackage ../../pkgs/pandora-chatgpt {})
    xfce.thunar
  ];

  xdg.enable = true;

  # -----------------
  # Enable Kdeconnect
  # -----------------

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    nvidiaPatches = false;

    extraConfig = with pkgs; ''
      # █▀▀ ▀▄▀ █▀▀ █▀▀
      # ██▄ █░█ ██▄ █▄▄
      # exec-once = wl-clipboard-history -t
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      # exec-once = wlsunset -t 4500 -S 9:00 -s 19:30
      exec-once = auto_start
      exec-once = systemctl --user restart pipewire
      exec-once = swaybg -m fill -i ~/.wallpapers/smile.jpg
      exec-once = waybar
      exec-once = fcitx5
      #exec-once = gBar bar 0

      # █▀▄▀█ █▀█ █▄░█ █ ▀█▀ █▀█ █▀█
      # █░▀░█ █▄█ █░▀█ █ ░█░ █▄█ █▀▄
      # monitor = eDP-1,2560x1600@60,0x0,1.5
      monitor = ,highres,auto,1.5
      # sets xwayland scale
      exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
      # toolkit-specific scale
      env = GDK_SCALE,2
      env = XCURSOR_SIZE,32

      # █ █▄░█ █▀█ █░█ ▀█▀
      # █ █░▀█ █▀▀ █▄█ ░█░
      input {
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      # █▀▀ █▀▀ █▄░█ █▀▀ █▀█ ▄▀█ █░░
      # █▄█ ██▄ █░▀█ ██▄ █▀▄ █▀█ █▄▄
      general {
        gaps_in=5
        gaps_out=5
        border_size=2
        col.active_border=0xff7D4045
        col.inactive_border=0xff382D2E
        no_border_on_floating = false
        layout = dwindle
        no_cursor_warps = true
      }

      # █▀▄▀█ █ █▀ █▀▀
      # █░▀░█ █ ▄█ █▄▄
      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        vfr = true
        enable_swallow = true
        swallow_regex = ^(wezterm)$
      }

      # █▀▄ █▀▀ █▀▀ █▀█ █▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
      # █▄▀ ██▄ █▄▄ █▄█ █▀▄ █▀█ ░█░ █ █▄█ █░▀█

      decoration {
        # █▀█ █▀█ █░█ █▄░█ █▀▄   █▀▀ █▀█ █▀█ █▄░█ █▀▀ █▀█
        # █▀▄ █▄█ █▄█ █░▀█ █▄▀   █▄▄ █▄█ █▀▄ █░▀█ ██▄ █▀▄
        rounding = 0
        multisample_edges = true

        # █▀█ █▀█ ▄▀█ █▀▀ █ ▀█▀ █▄█
        # █▄█ █▀▀ █▀█ █▄▄ █ ░█░ ░█░
        active_opacity = 1.0
        inactive_opacity = 1.0

        # █▄▄ █░░ █░█ █▀█
        # █▄█ █▄▄ █▄█ █▀▄
        blur = false
        blur_size = 3
        blur_passes = 3
        blur_new_optimizations = true


        # █▀ █░█ ▄▀█ █▀▄ █▀█ █░█░█
        # ▄█ █▀█ █▀█ █▄▀ █▄█ ▀▄▀▄▀
        drop_shadow = false
        shadow_ignore_window = true
        shadow_offset = 1 2
        shadow_range = 10
        shadow_render_power = 2
        col.shadow = 0x66404040

        #blurls = gtk-layer-shell
        # blurls = waybar
        blurls = lockscreen
      }

      # ▄▀█ █▄░█ █ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█
      # █▀█ █░▀█ █ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█
      animations {
        enabled = true
        # █▄▄ █▀▀ ▀█ █ █▀▀ █▀█   █▀▀ █░█ █▀█ █░█ █▀▀
        # █▄█ ██▄ █▄ █ ██▄ █▀▄   █▄▄ █▄█ █▀▄ ▀▄▀ ██▄
        bezier = overshot, 0.05, 0.9, 0.1, 1.05
        bezier = smoothOut, 0.36, 0, 0.66, -0.56
        bezier = smoothIn, 0.25, 1, 0.5, 1

        animation = windows, 1, 5, overshot, slide
        animation = windowsOut, 1, 4, smoothOut, slide
        animation = windowsMove, 1, 4, default
        animation = border, 1, 10, default
        animation = fade, 1, 10, smoothIn
        animation = fadeDim, 1, 10, smoothIn
        animation = workspaces, 1, 6, default

      }

      # █░░ ▄▀█ █▄█ █▀█ █░█ ▀█▀ █▀
      # █▄▄ █▀█ ░█░ █▄█ █▄█ ░█░ ▄█

      dwindle {
        no_gaps_when_only = false
        pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
      }

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█
      windowrule = float, file_progress
      windowrule = float, confirm
      windowrule = float, dialog
      windowrule = float, download
      windowrule = float, notification
      windowrule = float, error
      windowrule = float, splash
      windowrule = float, confirmreset
      windowrule = float, title:Open File
      windowrule = float, title:branchdialog
      windowrule = float, Lxappearance
      windowrule = float, Rofi
      windowrule = animation none,Rofi
      windowrule = float, viewnior
      windowrule = float, Viewnior
      windowrule = float, feh
      windowrule = float, pavucontrol-qt
      windowrule = float, pavucontrol
      windowrule = float, file-roller
      windowrule = float, title:DevTools
      windowrule = fullscreen, wlogout
      windowrule = float, title:wlogout
      windowrule = fullscreen, title:wlogout
      windowrule = idleinhibit focus, mpv
      windowrule = idleinhibit fullscreen, firefox
      windowrule = float, title:^(Media viewer)$
      windowrule = float, title:^(Volume Control)$
      windowrule = float, title:^(Picture-in-Picture)$
      windowrule = size 800 600, title:^(Volume Control)$
      windowrule = move 75 44%, title:^(Volume Control)$
      windowrule = opacity 0.92, Thunar

      # █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄
      # █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀

      # █▀ █▀▀ █▀█ █▀▀ █▀▀ █▄░█ █▀ █░█ █▀█ ▀█▀
      # ▄█ █▄▄ █▀▄ ██▄ ██▄ █░▀█ ▄█ █▀█ █▄█ ░█░

      bind = SUPER, v, exec, wf-recorder -f $(xdg-user-dir VIDEOS)/$(date +'%H:%M:%S_%d-%m-%Y.mp4')
      bind = SUPER SHIFT, v, exec, killall -s SIGINT wf-recorder
      bind = , Print, exec, screensht full
      bind = SUPERSHIFT, S, exec, screensht area

      # █▀▄▀█ █ █▀ █▀▀
      # █░▀░█ █ ▄█ █▄▄
      bind = SUPER SHIFT, X, exec, colorpicker
      # bind = CTRL ALT, L, exec, swaylock
      bind = SUPER, Return, exec, wezterm
      bind = SUPER, E, exec, thunar
      # bind = SUPER, D, exec, wofi --show drun -I -m -i
      # bind = SUPER, period, exec, wofi-emoji
      bind = SUPER, D, exec, killall rofi || rofi -show drun -theme ~/.config/rofi/global/rofi.rasi
      bind = SUPER, R, exec, killall rofi || rofi -show run -theme ~/.config/rofi/global/rofi.rasi
      #bind = SUPER, period, exec, killall rofi || rofi -show emoji -emoji-format "{emoji}" -modi emoji -theme ~/.config/rofi/global/emoji
      #bind = SUPER, escape, exec, wlogout --protocol layer-shell -b 5 -T 400 -B 400
      #bind = SUPER, F1, exec, keybind
      bind = SUPER SHIFT, B, exec, killall -SIGUSR2 waybar # Reload Waybar
      bind = SUPER, B, exec, killall -SIGUSR1 waybar

      # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀
      # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █░▀░█ █▀█ █░▀█ █▀█ █▄█ █░▀░█ ██▄ █░▀█ ░█░
      bind = SUPER, Q, killactive,
      bind = SUPER SHIFT, Q, exit,
      bind = SUPER, F, fullscreen,
      bind = SUPER, Space, togglefloating,
      bind = SUPER, P, pseudo, # dwindle
      bind = SUPER, S, togglesplit, # dwindle

      # █▀▀ █▀█ █▀▀ █░█ █▀
      # █▀░ █▄█ █▄▄ █▄█ ▄█
      bind = SUPER, h, movefocus, l
      bind = SUPER, l, movefocus, r
      bind = SUPER, k, movefocus, u
      bind = SUPER, j, movefocus, d

      # █▀▄▀█ █▀█ █░█ █▀▀
      # █░▀░█ █▄█ ▀▄▀ ██▄
      bind = SUPER SHIFT, left, movewindow, l
      bind = SUPER SHIFT, right, movewindow, r
      bind = SUPER SHIFT, up, movewindow, u
      bind = SUPER SHIFT, down, movewindow, d

      # █▀█ █▀▀ █▀ █ ▀█ █▀▀
      # █▀▄ ██▄ ▄█ █ █▄ ██▄
      bind = SUPER CTRL, left, resizeactive, -20 0
      bind = SUPER CTRL, right, resizeactive, 20 0
      bind = SUPER CTRL, up, resizeactive, 0 -20
      bind = SUPER CTRL, down, resizeactive, 0 20

      # ▀█▀ ▄▀█ █▄▄ █▄▄ █▀▀ █▀▄
      # ░█░ █▀█ █▄█ █▄█ ██▄ █▄▀
      bind= SUPER, g, togglegroup
      bind= SUPER, tab, changegroupactive

      # █▀ █▀█ █▀▀ █▀▀ █ ▄▀█ █░░
      # ▄█ █▀▀ ██▄ █▄▄ █ █▀█ █▄▄
      bind = SUPER, a, togglespecialworkspace
      bind = SUPERSHIFT, a, movetoworkspace, special
      bind = SUPER, c, exec, hyprctl dispatch centerwindow

      # █▀ █░█░█ █ ▀█▀ █▀▀ █░█
      # ▄█ ▀▄▀▄▀ █ ░█░ █▄▄ █▀█
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10
      bind = SUPER ALT, up, workspace, e+1
      bind = SUPER ALT, down, workspace, e-1

      # █▀▄▀█ █▀█ █░█ █▀▀
      # █░▀░█ █▄█ ▀▄▀ ██▄
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      # █▀▄▀█ █▀█ █░█ █▀ █▀▀   █▄▄ █ █▄░█ █▀▄ █ █▄░█ █▀▀
      # █░▀░█ █▄█ █▄█ ▄█ ██▄   █▄█ █ █░▀█ █▄▀ █ █░▀█ █▄█
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      bind = SUPER, mouse_down, workspace, e+1
      bind = SUPER, mouse_up, workspace, e-1    
    '';
  };

  home.file.".wallpapers" = {
    source = ./wallpapers;
    recursive = true;
  };
}
