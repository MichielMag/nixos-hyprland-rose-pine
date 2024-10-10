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
  environment.defaultPackages = with pkgs; [
    nvidia-offload
    nvidia-vaapi-driver
    libva-vdpau-driver
    libva-utils
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
    NVD_BACKEND = "direct";
  };
}
