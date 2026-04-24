{
  description = "Flake for Ash's config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages not available in nixpkgs/elsewhere
    mypkgs-ash = {
      url = "path:./nixos/packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote flake modules
    wrappers = {
      url = "github:midischwarz12/nix-wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote flake packages
    ash-quickshell-flake = {
      url = "github:ashametrine/ash-quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    awww-flake = {
      url = "git+https://codeberg.org/LGFae/awww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iamb-flake = {
      url = "github:ulyssa/iamb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    codex-cli-nix = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      disko,
      mypkgs-ash,
      ash-quickshell-flake,
      awww-flake,
      iamb-flake,
      codex-cli-nix,
      wrappers,
    }:
    let
      lib = nixpkgs.lib;
      systems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs systems;
      overlay =
        final: prev:
        let
          system = prev.stdenv.hostPlatform.system;
          unstablePkgs = nixpkgs-unstable.legacyPackages.${system};
        in
        {
          unstable = unstablePkgs;
          jujutsu = unstablePkgs.jujutsu;
          ashpkgs = mypkgs-ash.legacyPackages.${system};
          ash-quickshell = ash-quickshell-flake.packages.${system}.default;
          iamb = iamb-flake.packages.${system}.default;
          awww = awww-flake.packages.${system}.default;
          codex = codex-cli-nix.packages.${system}.default;
        };
      nixpkgs-overlay-module = (
        { ... }:
        {
          nixpkgs.overlays = [ overlay ];
        }
      );
    in
    {
      overlays.default = overlay;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        l15v3 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixpkgs-overlay-module
            disko.nixosModules.disko
            wrappers.nixosModules.nixos-wrappers

            ./nixos/overrides/limine/default.nix
            ./nixos/hosts/l15v3/l15v3.nix
            ./nixos/hosts/l15v3/disko.nix
            ./nixos/hosts/l15v3/hardware-configuration.nix

            ./nixos/modules/configuration.nix
            # Optional modules
            ./nixos/modules/neovim.nix
            ./nixos/modules/i2p.nix
            ./nixos/modules/tor.nix
            ./nixos/modules/fcitx5.nix
            ./nixos/modules/librewolf.nix
            ./nixos/modules/gtk-theme.nix
            ./nixos/modules/wayland.nix
          ];
        };
        installationIso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos/hosts/installation/installation.nix ];
        };
        codexVM = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixpkgs-overlay-module
            ./nixos/hosts/codex-vm/vm.nix
          ];
        };
      };

      apps = forAllSystems (system: {
        disko = {
          type = "app";
          program = "${disko.packages.${system}.disko}/bin/disko";
        };
        codex-vm = {
          type = "app";
          program = "${self.nixosConfigurations.codexVM.config.system.build.vm}/bin/run-codex-vm-vm";
        };
      });

      images = {
        installation = self.nixosConfigurations.installationIso.config.system.build.isoImage;
      };
    };
}
