{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.programs.quickemu;
    homeDirectory = config.home.homeDirectory;
    vmType = (import ./vm-type.nix { inherit homeDirectory lib pkgs; }).vmType;
    vms = filterAttrs (n: f: f.enable);

    makeConfig = name: vm: {
            text = ''
                name: ${name}
                os: ${vm.os}
                release: ${vm.release}
            '';
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
            description = "Attribute set of VMs to create in your home folder";
            default = {};
            type = vmType;
        };
    };  
    config = mkIf cfg.enable {
        #traced = trace cfg.vm;
        home.packages = with pkgs; [
            quickemu
        ];
        # home.file.".quickemu/trace" = generators.toJSON { config = cfg; };
        #home.file = (mapAttrs' (name: vm: nameValuePair (".quickemu/${name}") (vm: makeConfig name vm)) cfg.vm);
    };
}