{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.oh-my-posh;

in {
    options.modules.oh-my-posh = { enable = mkEnableOption "oh-my-posh"; };
    config = mkIf cfg.enable {

        home.file.".config/oh-my-posh/config.json".source = ./.config/oh-my-posh/config.json;
        
        programs.oh-my-posh = {
            enable = true;
        };
    };
}
