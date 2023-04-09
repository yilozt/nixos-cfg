{ pkgs, ... }:
{
  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
      size = "16x16";
    };
    settings = {
      global = {
        follow = "mouse";
        indicate_hidden = "yes";

        offset = "10x10";

        notification_height = 0;

        separator_height = 2;

        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 2;

        frame_color = "#5F332F";
        separator_color = "frame";

        sort = "yes";
        idle_threshold = 120;
        font = "monospace 10";
        line_height = 0;
        markup = "full";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        word_wrap = "yes";
        stack_duplicates = true;
        hide_duplicate_count = false;

        show_indicators = "yes";

        min_icon_size = 0;
        max_icon_size = 64;

        dmenu = "rofi -p dunst:";
        browser = "microsoft-edge --new-tab";

        title = "Dunst";
        class = "Dunst";

        corner_radius = 10;
        timeout = 5;
      };

      urgency_low = {
        background = "#1D2021";
        foreground = "#5F332F";
      };
      urgency_normal = {
        background = "#1D2021";
        foreground = "#E8E3E3";
      };
      urgency_critical = {
        background = "#1D2021";
        foreground = "#AD685A";
        frame_color = "#DD8F6E";
      };
    };
  };
}
