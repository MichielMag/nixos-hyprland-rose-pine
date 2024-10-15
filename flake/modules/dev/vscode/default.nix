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

    home.activation = {
      vscodeActivation = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        				run rm -f $HOME/.config/Code/User/settings.json;
                run ln -s $HOME/.dotfiles/.config/Code/User/settings.json $HOME/.config/Code/User/settings.json;
                run rm -f $HOME/.vscode/argv.json;
                run ln -s $HOME/.dotfiles/.vscode/argv.json $HOME/.vscode/argv.json;
      '';
    };

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      extensions = with pkgs; [
        vscode-extensions.github.copilot
        vscode-extensions.github.copilot-chat

        vscode-extensions.jock.svg

        vscode-extensions.mvllow.rose-pine
        vscode-extensions.vscode-icons-team.vscode-icons

        vscode-extensions.mkhl.direnv
        vscode-extensions.dbaeumer.vscode-eslint
        vscode-extensions.stylelint.vscode-stylelint
        vscode-extensions.esbenp.prettier-vscode
        vscode-extensions.bbenoist.nix
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.eamodio.gitlens
      ];
      package = pkgs.vscode.override {
        commandLineArgs = "--use-gl=egl";
      };
    };
  };
}
