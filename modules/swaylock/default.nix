{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.swaylock;

in {
    options.modules.swaylock= { enable = mkEnableOption "swaylock"; };
    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            swaylock-effects
        ];

        home.file.".config/swaylock/config".source = ./.config/swaylock/config;

        programs.swaylock = {
            enable = true;
            package = pkgs.swaylock-effects;
        };
    };
}
