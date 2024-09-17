{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.programs.quickemu;
    homeDirectory = config.home.homeDirectory;
    vmType = (import ./vm-type.nix { inherit homeDirectory lib pkgs; }).vmType;
    vms = filterAttrs (n: f: f.enable);

    makeConfig = name: home: vm: {
        home.file.".quickemu/${name}" = {
            text = ''
                name: ${name}
                os: ${vm.os}
                release: ${vm.release}
            '';
        };
    };

    makeConfigurations = forEach (n: vm: makeConfig n config home vm);
in {
    options.programs.quickemu = { 
        enable = mkEnableOption "quickemu"; 

        package = mkOption {
            type = types.package;
            default = pkgs.quickemu;
            defaultText = literalExpression "pkgs.quickemu";
            description = ''
                quickemu package to use
            '';
        };

        vm = mkOption {
            description = "Attribute set of VMs to create";
            default = {};
            type = vmType;
        };
    };

    
    config = mkIf cfg.enable (lib.mkMerge [

        {
            home.packages = with pkgs; [
                quickemu
            ];
        }

        (makeConfig "quickemu" homeDirectory cfg.vm)
        # mapAttrs (name: value: makeConfig name home value) (filterAttrs (n: vm: vm.enable) cfg.vm)        


        #home.file.".config/vm-windows/adi1090x" = {
        #    source = "${adi1090x-vm-windows}/files";
        #    recursive = true;
        #    target = ".config/vm-windows/adi1090x";
        #};

        #home.file.".local/share/fonts" = {
        #    source = "${adi1090x-vm-windows}/fonts";
        #    recursive = true;
        #};
    ]);
}
