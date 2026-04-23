{ modulesPath, pkgs, ... }:
{
  imports = [ (modulesPath + "/virtualisation/qemu-vm.nix") ];

  networking = {
    hostName = "codex-vm";
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    getty.autologinUser = "codex";
  };

  users.users = {
    root.initialPassword = "root";
    codex = {
      isNormalUser = true;
      initialPassword = "codex";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHMSXIcvvgQOpDaAaSi3OvuvF0YwcKyi0QKxkVDBiFCC openpgp:0xEA2361DE"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  programs.git.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    jujutsu
    vim
    codex
    playwright-mcp

    ripgrep
  ];

  virtualisation = {
    cores = 2;
    memorySize = 8192;
    graphics = false;
    sharedDirectories = {
      projects = { 
        source = "/home/Ash/Dev";
        target = "/home/codex/Dev";
        securityModel = "mapped-file";
      };
    };
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
    ];
  };

  system.stateVersion = "25.11";
}
