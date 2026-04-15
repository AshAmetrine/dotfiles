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
      url = "path:./packages";
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
      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system};
        ashpkgs = mypkgs-ash.legacyPackages.${prev.stdenv.hostPlatform.system};
        ash-quickshell = ash-quickshell-flake.packages.${prev.stdenv.hostPlatform.system}.default;
        iamb = iamb-flake.packages.${prev.stdenv.hostPlatform.system}.default;
        awww = awww-flake.packages.${prev.stdenv.hostPlatform.system}.default;
        codex = codex-cli-nix.packages.${prev.stdenv.hostPlatform.system}.default;
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

            ./overrides/limine/default.nix
            ./hosts/l15v3/l15v3.nix
            ./hosts/l15v3/disko.nix
            ./hosts/l15v3/hardware-configuration.nix

            ./modules/configuration.nix
            # Optional modules
            ./modules/neovim.nix
            ./modules/i2p.nix
            ./modules/tor.nix
            ./modules/fcitx5.nix
            ./modules/librewolf.nix
            ./modules/gtk-theme.nix
            ./modules/wayland.nix
          ];
        };
        installationIso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/installation/installation.nix ];
        };
      };

      apps = forAllSystems (system: {
        disko = {
          type="app";
          program = "${disko.packages.${system}.disko}/bin/disko";
        };
      });

      images = {
        installation = self.nixosConfigurations.installationIso.config.system.build.isoImage;
      };
    };
}
