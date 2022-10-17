# Custom settings of gsettings & programs

{ pkgs, lib, ... }:

let

  # Extensions list
  # use `passthru.extensionUuid` to get uuid of extensions
  extensions = with pkgs.gnomeExtensions; [
    arcmenu
    gsconnect
    alphabetical-app-grid
    dash-to-dock
    # dynamic-panel-transparency
    # just-perfection
    lock-keys
    tray-icons-reloaded
    gtk-title-bar
    user-themes
    vitals
    x11-gestures
  ];

  # UUID list of extensions
  uuid = builtins.map (e: e.passthru.extensionUuid) extensions;
in

{

  # Gnome shell extensions
  home.packages = extensions;

  # Dconf settings of gnome application / extensions
  dconf.settings = with lib.hm.gvariant; {

    # Receive email when application closes
    "org/gnome/Geary" = {
      startup-notifications = true;
    };

    # --------------- Gnome Shell ----------------

    "org/gnome/shell" = {
      disable-extension-version-validation = true;
      disable-user-extensions = false;
      enabled-extensions = uuid ++ [
        "rounded-window-corners@yilozt"
        "material-you-theme@asubbiah.com"
      ];
      disabled-extensions = [ ];
    };

    # ------------- Gnome extensions -------------

    "org/gnome/shell/extensions/alphabetical-app-grid" = {
      folder-order-position = "alphabetical";
      show-favourite-apps = false;
    };

    # Setting of Arc Menu
    "org/gnome/shell/extensions/arcmenu" = {
      runner-menu-hotkey = "Custom";
      show-activities-button = false;
      toggle-runner-menu = [ "<Super>x" ];
      menu-layout = "GnomeOverview";
      menu-hotkey = "Super_L";
      menu-button-icon = "Arc_Menu_Icon";
      multi-monitor = true;
    };

    "org/gnome/shell/extensions/gsconnect" = {
      enabled = true;
      name = "luo";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      autohide = true;
      click-action = "focus-minimize-or-previews";
      custom-theme-shrink = true;
      customize-alphas = true;
      dash-max-icon-size = 24;
      disable-overview-on-startup = true;
      dock-position = "LEFT";
      extend-height = true;
      height-fraction = 0.93999999999999995;
      icon-size-fixed = false;
      intellihide = false;
      intellihide-mode = "ALL_WINDOWS";
      isolate-monitors = true;
      isolate-workspaces = false;
      max-alpha = 0.84999999999999998;
      min-alpha = 0.34000000000000002;
      multi-monitor = true;
      preview-size-scale = 0.23999999999999999;
      running-indicator-style = "DOTS";
      scroll-to-focused-application = true;
      show-apps-at-top = false;
      show-favorites = true;
      show-mounts = false;
      show-running = true;
      show-show-apps-button = true;
      show-trash = false;
      show-windows-preview = true;
      transparency-mode = "DYNAMIC";
      workspace-agnostic-urgent-windows = true;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      enable-background-color = false;
      enable-opacity = true;
      hide-corners = true;
      icon-shadow-position = mkTuple [ 0 2 5 ];
      maximized-opacity = 255;
      panel-color = mkTuple [ 0 82 46 ];
      remove-panel-styling = true;
      transition-speed = 533;
      unmaximized-opacity = 29;
    };

    "org/gnome/shell/extensions/just-perfection" = {
      accessibility-menu = false;
      activities-button = false;
      app-menu = false;
      clock-menu-position = 0;
      clock-menu-position-offset = 0;
      dash-separator = false;
      keyboard-layout = false;
      startup-status = 0;
      weather = false;
      world-clock = false;
    };

    "org/gnome/shell/extensions/lockkeys" = {
      notification-preferences = "osd";
      style = "show-hide";
    };

    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-size = 16;
      icons-limit = 1;
      tray-position = "right";
      wine-behavior = false;
    };

    "org/gnome/shell/extensions/gtktitlebar" = {
      hide-window-titlebars = "both";
      restrict-to-primary-screen = true;
    };

    "org/gnome/shell/extensions/vitals" = {
      alphabetize = "true";
      fixed-widths = "true";
      hot-sensors = [ "_memory_usage_" "__network-rx_max__" "_processor_usage_" ];
      position-in-panel = 0;
      show-battery = false;
      show-fan = false;
      show-memory = true;
      show-storage = false;
      show-temperature = false;
      show-voltage = false;
      update-time = 5;
      use-higher-precision = false;
    };

    "org/gnome/shell/extensions/x11gestures" = {
      swipe-fingers = 3;
    };
  };
}
