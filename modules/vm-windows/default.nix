{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.vm-windows;
    quickemu-pkg = pkgs.fetchFromGitHub {
        owner = "MichielMag";
        repo = "quickemu";
        rev = "3e842430d0f76fed9a5c7537f3ec39b91b931669";
        sha256 = "0000";
    };
    quickget = pkgs.writeShellScriptBin "quickget" ''${builtins.readFile ("${quickemu-pkg}/quickget")}'';
in {
    options.modules.vm-windows = { enable = mkEnableOption "vm-windows"; };

    config = mkIf cfg.enable {

        home.packages = with pkgs; [
            quickemu
        ];


        programs.quickemu = {
            enable = true;
            quickget = "${quickemu-pkg}/quickget";
        };
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
