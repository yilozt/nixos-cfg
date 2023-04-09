{ pkgs, ... }:

{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];

    inputMethod = {
      enabled = "fcitx5";
      # ibus.engines = with pkgs.ibus-engines; [ libpinyin rime ];

      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
        fcitx5-gtk
        libsForQt5.fcitx5-qt
      ];
    };
  };
}
