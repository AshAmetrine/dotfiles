{
  lib,
  pkgs,
  ...
}:
{
  system.stateVersion = "25.11";

  boot.loader.limine = {
    enable = true;
    efiSupport = false;
    biosSupport = true;
    biosDevice = lib.mkDefault "/dev/sda";
    maxGenerations = 3;
    resolution = "1920x1080x32";
    style = {
      wallpapers = [ ./sophia.png ];
      interface = {
        resolution = "1920x1080";
        helpHidden = true;
      };

      graphicalTerminal = {
        background = "6624283B";
        foreground = "C0CAF5";
        palette = "1D202F;F7768E;9ECE6A;E0AF68;7AA2F7;BB9AF7;7DCFFF;A9B1D6";
        brightPalette = "414868;FF899D;9FE044;FABA4A;8DB0FF;C7A9FF;A4DAFF;C0CAF5";
      };
    };
  };

  console.keyMap = "uk";
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";

  networking = {
    hostName = "l15v3-c7f5";
    useDHCP = true;
    wireless.iwd.enable = true;
  };

  users.users = {
    ash = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
      ];
    };
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "trezor-suite"
        "veracrypt"
      ];
  };

  services = {
    xserver = {
      xkb.layout = "gb";
      videoDrivers = [ "modesetting" ];
      deviceSection = ''
        Option "TearFree" "true"
      '';
    };

    trezord.enable = true;

    # Enable periodic SSD TRIM
    fstrim.enable = true;

    power-profiles-daemon.enable = true;
    pcscd.enable = true;
    thermald.enable = true;
    upower.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true;
  };

  hardware.nitrokey.enable = true;

  wrappers = {
    # Defaults to X11 otherwise
    trezor-suite = {
      executables.trezor-suite.args.prefix = [ "--ozone-platform=wayland" ];
      systemWide = true;
    };
  };

  powerManagement.powertop.enable = true;

  environment.systemPackages = with pkgs; [
    acpi
    monero-gui
    keepassxc
    #nitrokey-app
    nitrokey-app2
    pynitrokey
    impala # Manage iwd
  ];
}
