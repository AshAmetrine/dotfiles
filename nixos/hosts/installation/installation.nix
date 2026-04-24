{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];

  console.keyMap = "uk";

  networking = {
    networkmanager.enable = lib.mkForce false;
    wireless.iwd.enable = true;
    useDHCP = true;
  };

  services.getty.helpLine = lib.mkForce ''
    This is a custom installation image. 

    The "nixos" and "root" accounts have empty passwords.

    An ssh public key has been included for the "nixos" user.

    To set up a wireless connection, run `impala`.

    Run 'nixos-help' for the NixOS manual.
  '';

  services.openssh = {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "overload(control, esc)";
        esc = "capslock";
      };
    };
  };

  users.users.nixos = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHDQ8Apu8/v8abtjZqT6iqhRC1DSL1AhFshdFYnrYlCx openpgp:0x2C72CD2D"
    ];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    impala
    ((vim.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = ''
        map Q <Nop>
        map ; :
      '';
    })
  ];
}
