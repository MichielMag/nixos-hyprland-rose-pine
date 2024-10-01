{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.programs.quickemu;
    homeDirectory = config.home.homeDirectory;
    vmType = (import ./vm-type.nix { inherit homeDirectory lib pkgs; }).vmType;
    vms = filterAttrs (n: f: f.enable);

    makeIniContent = homePath: vm: lib.generators.toINI {
        "" = {
            guest_os = vm.guest;
            disk_img = "${homeDirectory}/${homePath}/${vm.name}/disk.qcow2";
            ${vm.imageType} = "${homeDirectory}/${homePath}/${vm.name}/${vm.name}.${vm.imageType}";
            disk_size = vm.diskSize;
            ram = vm.ram;
        } 
        // vm.osSpecifics 
        // (
            if hasAttr "guestToolsIsoFile" vm then {
                fixed_iso = "${homeDirectory}/${homePath}/${vm.name}/${vm.guestToolsIsoFile}";
            } else {}
        );
    };

    addGuestTools = vm: {
        inherit vm;
        guestToolsIsoFile = "guest-tools.iso";
    };

    makeConfig = homePath: quickemupath: name: vm: {
        text = makeIniContent homePath vm;
        executable = true;
    };

    web_get = import ./web-get.nix { inherit pkgs; };

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

        path = mkOption {
            type = types.str;
            default = ".quickemu";
            description = ''
                Path to store quickemu configurations
            '';
        };
    };  
    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            quickemu
        ];
        home.file = mapAttrs' (name: vm: {
            name = "${cfg.path}/${name}.conf";
            value = makeConfig cfg.path "${cfg.package}/bin/quickemu" name vm;
        }) cfg.vm;
    };
}