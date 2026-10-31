{ config, pkgs, ... }:
{
  imports = [
    ../overlays/waylock.nix
  ];

  wrappers = {
    fuzzel = {
      executables.fuzzel.args.prefix = [
        "--config"
        "${./configs/fuzzel/fuzzel.ini}"
      ];
      systemWide = true;
    };

    waylock = {
      executables.waylock.args.prefix = [
        "-init-color"
        "0x4f525c"
        "-input-color"
        "0x005577"
        "-fail-color"
        "0xCC3333"
      ];
      systemWide = true;
    };

    swayidle = {
      executables.swayidle.args.prefix = [
        "-w"
        "-C"
        "${./configs/swayidle/swayidle.conf}"
      ];
      systemWide = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      ash-quickshell
      awww
      swayimg
      wayclip
    ];
    sessionVariables = {
      # Some apps don't run under wayland without this
      QT_QPA_PLATFORM = "wayland";
    };
  };

  programs = {
    niri.enable = true;
  };

  i18n.inputMethod.fcitx5.waylandFrontend = true;

  services = {
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      };
      useTextGreeter = true;
    };
  };

  security.pam.services.waylock.nodelay = true;

  xdg.mime.defaultApplications = {
    "image/*" = "swayimg.desktop";
  };
}
