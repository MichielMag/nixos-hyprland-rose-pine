{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.vscode;
  code-recent = pkgs.writeShellScriptBin "code-recent" ''${builtins.readFile ./.scripts/rofi-vscode-recents.sh}'';
  dotnet-full =
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      runtime_8_0
      aspnetcore_8_0
    ];
in
{
  options.modules.vscode = {
    enable = mkEnableOption "vscode";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixfmt-rfc-style
      code-recent
      dotnet-full
      icu.dev
      icu
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

        vscode-marketplace.ms-vscode.vscode-copilot-data-analysis
        vscode-marketplace.ms-vscode.vscode-websearchforcopilot
        vscode-marketplace.ms-vscode.vscode-commander
        vscode-marketplace.ms-vscode.vscode-copilot-vision

        vscode-marketplace.ms-dotnettools.vscode-dotnet-runtime
        vscode-marketplace.ms-dotnettools.csdevkit
        vscode-marketplace.ms-dotnettools.csharp
        vscode-marketplace.ms-dotnettools.vscodeintellicode-csharp
        vscode-marketplace.adrianwilczynski.user-secrets

      ];
      package = pkgs.vscode.override {
        commandLineArgs = "--use-gl=egl --enable-features=WebRTCPipeWireCapturer";
      };
    };
  };
}
