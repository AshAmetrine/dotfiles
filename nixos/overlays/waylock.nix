{ ... }: {
  nixpkgs.overlays = [
    (
      final: prev:
      let
        image = ./waylock/background.jpg;
      in
      {
        waylock = prev.waylock.overrideAttrs (oldAttrs: {
          src = prev.fetchFromGitea {
            domain = "codeberg.org";
            owner = "AshAmetrine";
            repo = "waylock";
            rev = "68eac603e32aa6a35ac7e82e3c658be3ab6b4bc7";
            sha256 = "sha256-GtEUWAyngiuVkFf22KVGWaO/9Rg858Z6+CidLTWycM8=";
          };
          zigBuildFlags = (oldAttrs.zigBuildFlags or [ ]) ++ [ "-Dimage=${image}" ];
          deps = prev.callPackage ./waylock/build.zig.zon.nix { };
        });
      }
    )
  ];
}
