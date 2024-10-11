{
  inputs,
  pkgs,
  config,
  ...
}:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  environment.defaultPackages = with pkgs; [
    nvidia-offload
    libva-utils
  ];

  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
    intel-media-driver
    libvdpau-va-gl
    libva-vdpau-driver
    vpl-gpu-rt
  ];
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "iHD";
    AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1";
  };
}
