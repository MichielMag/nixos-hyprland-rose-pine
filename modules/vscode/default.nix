{ pkgs, lib, config, ... }:

with lib;
let cfg = 
    config.modules.vscode;
    
in {
    options.modules.vscode = { enable = mkEnableOption "vscode"; };
    config = mkIf cfg.enable {
        home.file.".config/Code/User/settings_source.json" = {
            source = ./.config/Code/User/settings.json;
            target = ".config/Code/User/settings_source.json";
            onChange = "if [ ! -f $HOME/.config/Code/User/settings.json]:
                            cat ~/.config/Code/User/settings_source.json > ~/.config/Code/User/settings.json
                            chmod 400 ~/.config/Code/User/settings.json
                        fi";
        };
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
