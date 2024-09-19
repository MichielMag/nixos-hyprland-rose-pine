{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.vm-windows;
    quickemu-pkg = pkgs.fetchFromGitHub {
        owner = "MichielMag";
        repo = "quickemu";
        rev = "60741d355eca887624889a21e876daf3f758bbcc";
        sha256 = "0000000000000000000000000000000000000000000000000000";
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
            vm."windows-11" = {
                os = "windows";
                enable = true;
                release = "11";
                language = "English (United States)";
            };
            vm."windows-10" = {
                os = "windows";
                enable = true;
                release = "10";
                language = "English (United States)";
            };
            vm."macos" = {
                os = "macos";
                enable = true;
                release = "catalina";
                language = "English (United States)";
            };
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
