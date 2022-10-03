{ pkgs, ... }:

let prime-run = pkgs.writeShellScriptBin "prime-run" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __VK_LAYER_NV_optimus=NVIDIA_only
  exec "$@"
'';
in
{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver vaapiIntel libvdpau-va-gl vaapiVdpau ];
  };
  hardware.nvidia = {
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement.enable = true;
  };

  environment.systemPackages = with pkgs; [
    prime-run
  ];
  environment.variables.VK_ICD_FILENAMES = [ "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json" ];
}
