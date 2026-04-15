{ ... }: {
  nixpkgs.overlays = [
    (final: prev: let 
      image = ./waylock/background.jpg;
    in {
      waylock = prev.waylock.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitea {
          domain = "codeberg.org";
          owner = "AshAmetrine";
          repo = "waylock";
          rev = "494f498aab7a0e2dfe86d3ca2a22abf9b8e1a099";
          sha256 = "sha256-gI6Fxs2tUBqr9HSIRJcQR2pQOEsGrxv8jr5DgJRTsDg=";
        };
        zigBuildFlags = (oldAttrs.zigBuildFlags or []) ++ [ "-Dimage=${image}" ];
        deps = prev.callPackage ./waylock/build.zig.zon.nix { };
      });
    })
  ];
}
