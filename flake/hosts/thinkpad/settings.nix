{
  inputs,
  pkgs,
  stable,
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
  lcdshadowctl = pkgs.writeShellScriptBin "lcdshadowctl" ''
    if [ $# -eq 0 ]; then
    	echo "Usage: $0 {toggle|on|off}"
    	exit 1
    fi

    on() {
    	echo 1 > /proc/acpi/ibm/lcdshadow
    }

    off() {
    	echo 0 > /proc/acpi/ibm/lcdshadow
    }

    toggle() {
    	status=$(awk '/status:/ {print $2}' /proc/acpi/ibm/lcdshadow)
    	if [ "$status" -eq "0" ]; then
    		on
    	else
    		off
    	fi
    }

    case "$1" in
    	toggle)
    		toggle
    		;;
    	on)
    		on
    		;;
    	off)
    		off
    		;;
    	*)
    		echo "Invalid option: $1"
    		echo "Usage: $0 {toggle|on|off}"
    		exit 1
    		;;
    esac

  '';
in
{
  imports = [ ../../modules/nixos/default.nix ];

  modules = {
    evolution.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };

  environment.defaultPackages = with pkgs; [
    nvidia-offload
    libva-utils
    lcdshadowctl
  ];

  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
    intel-media-driver
  ];
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "iHD";
  };
}
