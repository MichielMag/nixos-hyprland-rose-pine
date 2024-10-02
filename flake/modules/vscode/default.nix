{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.vscode;

in
{
  options.modules.vscode = {
    enable = mkEnableOption "vscode";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
    home.file.".config/Code/User/settings.json" = {
      source = ./.config/Code/User/settings.json;
      target = ".config/Code/User/settings_source.json";
      onChange = "test -f $HOME/.config/Code/User/settings.json || { 
                        cat $HOME/.config/Code/User/settings_source.json > $HOME/.config/Code/User/settings.json; 
                        chmod ug+rw $HOME/.config/Code/User/settings.json; }";
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
        vscode-extensions.bbenoist.nix
        vscode-extensions.jnoortheen.nix-ide
      ];
    };
  };
}
