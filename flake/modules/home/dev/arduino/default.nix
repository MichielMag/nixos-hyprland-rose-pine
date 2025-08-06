{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.arduino;
  arduino-ide_with_pyserial =
    with pkgs;
    arduino-ide.override {
      appimageTools = appimageTools // {
        wrapType2 =
          args:
          appimageTools.wrapType2 (
            args
            // {
              extraPkgs =
                pkgs:
                args.extraPkgs pkgs
                ++ [
                  (pkgs.python3.withPackages (m: [ m.pyserial ]))
                ];
            }
          );
      };
    };
in
{
  options.modules.arduino = {
    enable = mkEnableOption "arduino";
  };
  config = mkIf cfg.enable {
    home.packages = [
      arduino-ide_with_pyserial
    ];
  };
}
