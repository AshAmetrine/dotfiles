{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            BIOS = {
              size = "1M";
              type = "EF02";
            };

            boot = {
              size = "512M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                # allow TRIM (Security: This can leak metadata)
                settings.allowDiscards = true;

                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}
