{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../overlays/oreo-cursors-plus.nix
    ../overlays/veracrypt.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
  };

  networking = {
    firewall = {
      enable = true;
      allowPing = false;
    };
  };

  users.defaultUserShell = pkgs.fish;
  security.sudo.wheelNeedsPassword = false;
  security.rtkit.enable = true;

  fonts = {
    fontDir.enable = true;
    fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
    packages = with pkgs; [
      nerd-fonts.fira-code
      fira-code
      noto-fonts-color-emoji
      font-awesome
      ashpkgs.dudu-calligraphy
      ipafont # Japanese
      wqy_microhei # Chinese
    ];
  };

  hardware = {
    graphics.enable = true;
  };

  programs = {
    bash = {
      promptInit = ''
        array=(ϕ λ)
        idx=$((RANDOM % 2))
        PS1="\n\$(pwd) ''${array[$idx]} ";
        unset array idx
      '';
    };

    # nix-direnv is enabled by default
    direnv.enable = true;

    fish = {
      enable = true;
      interactiveShellInit = lib.strings.fileContents ./configs/fish/fish_config.fish;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    light = {
      enable = true;
      brightnessKeys.enable = true;
    };
  };

  wrappers = {
    dunst = {
      executables.dunst.args.prefix = [
        "-conf"
        "${./configs/dunst/dunstrc}"
      ];
      systemWide = true;
    };
    kitty = {
      executables.kitty.args.prefix = [
        "-c"
        "${./configs/kitty/kitty.conf}"
      ];
      systemWide = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      ttyper
      oreo-cursors-plus
      libnotify
      gnupg
      #cryfs
      veracrypt # (considered unfree)

      # Communication
      iamb
      aerc
      #neomutt
      #element-desktop
      vesktop

      # Web Related
      yt-dlp
      qutebrowser
      nnn

      # Dev Tools
      codex
      git
      jujutsu

      any-nix-shell
      license-cli
      #nixops_unstable_minimal

      # Langs
      gcc
      python3

      # Formatters
      nixfmt-rfc-style

      # Other
      udiskie
      ripgrep
      openssl
      mpv
      zathura
      gimp
      imagemagick
      cryptsetup
      htop
      dtach
      qemu
      pandoc
      pciutils
      usbutils
      unzip
      zip
    ];
    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  qt = {
    enable = true;
  };

  services = {
    mullvad-vpn.enable = true;
    udisks2.enable = true;
    gnome.gnome-keyring.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      audio.enable = true;

      wireplumber = {
          enable = true;
          configPackages = [
            (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
              monitor.bluez.properties = {
                bluez5.enable-hw-volume = false,
              }

              monitor.bluez.rules = [
                {
                  matches = [ { "device.api" = "bluez5" } ]
                  actions = { update-props = { "node.volume" = 0.0 } }
                }
              ]
            '')
            (pkgs.writeTextDir "share/wireplumber/alsa.lua.d/51-alsa-default-volume.lua" ''
              monitor.alsa.rules = [
                {
                  matches = [ { "device.api" = "alsa" } ]
                  actions = { update-props = { "node.volume" = 0.0 } }
                }
              ]
            '')
          ];
        };
    };

    getty.greetingLine = ''
      \e[38;5;25mNixOS ${config.system.nixos.label} (\m) - \l

      Welcome to Krat!
    '';

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main = {
          capslock = "overload(control, esc)";
          esc = "capslock";
        };
      };
    };
  };

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Tokyonight-storm
  console.colors = [
    "1D202F"
    "F7768E"
    "9ECE6A"
    "E0AF68"
    "7AA2F7"
    "BB9AF7"
    "7DCFFF"
    "A9B1D6"

    "414868"
    "FF899D"
    "9FE044"
    "FABA4A"
    "8DB0FF"
    "C7A9FF"
    "A4DAFF"
    "C0CAF5"
  ];
}
