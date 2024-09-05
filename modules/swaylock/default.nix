{ inputs, pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.swaylock;
    lock = pkgs.writeShellScriptBin "lock" ''${builtins.readFile ./.scripts/swaylock/lock.sh}'';
in {
    options.modules.swaylock= { enable = mkEnableOption "swaylock"; };
    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            swaylock-effects lock
        ];

        home.file.".config/swaylock/config".source = ./.config/swaylock/config;

        programs.swaylock = {
            enable = true;
            package = pkgs.swaylock-effects;
        };
    };
}
