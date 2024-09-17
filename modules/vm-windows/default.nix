{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.vm-windows;
    quickemu-pkg = pkgs.fetchFromGitHub {
        owner = "MichielMag";
        repo = "quickemu";
        rev = "0000000000000000000000000000000000000000000000000000";
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
            vm.windows = {
                enable = true;
                release = "11";
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
