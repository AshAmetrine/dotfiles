{ pkgs, ... }:
let
  theme-name = "Tokyonight-Dark";
  icon-theme = "BeautyLine";
in
{
  environment = {
    systemPackages = with pkgs; [
      tokyonight-gtk-theme
      beauty-line-icon-theme
    ];

    variables.GTK_THEME = theme-name;

    etc = {
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = ${theme-name}
        gtk-icon-theme-name = ${icon-theme}
      '';
      "xdg/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name = ${theme-name}
        gtk-icon-theme-name = ${icon-theme}
      '';
      "gtk-2.0/gtkrc".text = ''
        gtk-theme-name="${theme-name}"
        gtk-icon-theme-name="${icon-theme}"
      '';
    };
  };

  programs.dconf.profiles.user = {
    databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = theme-name;
            icon-theme = icon-theme;
          };
        };
      }
    ];
  };
}
