{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      veracrypt = prev.veracrypt.overrideAttrs (oldAttrs: {
        makeFlags = (oldAttrs.makeFlags or [ ]) ++ [ "NOGUI=1" ];
      });
    })
  ];
}
