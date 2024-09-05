{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.vscode;
    
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        programs.vscode = {
            enable = true;
            mutableExtensionsDir = true;
            extensions = with pkgs; [
                vscode-extensions.github.copilot
                vscode-extensions.github.copilot-chat
                
                vscode-extensions.jock.svg

                vscode-extensions.mvllow.rose-pine

                vscode-extensions.dbaeumer.vscode-eslint
                vscode-extensions.stylelint.vscode-stylelint
                vscode-extensions.esbenp.prettier-vscode
            ];
        };
    };
}
