{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.programs.quickget;

in {
    options.programs.quickget = { 
        enable = mkEnableOption "quickemu"; 

        package = mkOption {
            type = types.package;
            default = pkgs.quickemu;
            defaultText = literalExpression "pkgs.quickemu";
            description = ''
                quickemu package to use
            '';
        };

        quickget = mkOption {
            type = types.path;
            default = pkgs.writeShellScriptBin "quickget" ''${builtins.readFile ("${pkgs.quickemu}/quickget")}'';
            description = ''
                quickget script to use
            '';
        };
    };

    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            quickemu
        ];

        #home.file.".config/vm-windows/adi1090x" = {
        #    source = "${adi1090x-vm-windows}/files";
        #    recursive = true;
        #    target = ".config/vm-windows/adi1090x";
        #};

        #home.file.".local/share/fonts" = {
        #    source = "${adi1090x-vm-windows}/fonts";
        #    recursive = true;
        #};
    };
}
