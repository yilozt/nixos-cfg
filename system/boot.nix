{ pkgs, ... }: {
  boot = {
    supportedFilesystems = [ "ntfs" ];
    
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };

    # Linux kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Setup keyfile
    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };
}
