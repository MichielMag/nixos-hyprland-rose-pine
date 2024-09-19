{ homeDirectory, lib, pkgs }:

let
  inherit (lib)
    hasPrefix hm literalExpression mkDefault mkIf mkOption removePrefix types mkEnableOption;
    diskSizes = {
        "windows" = "64G";
        "macos" = "128G";
    };
    ram = {
        "windows" = "4G";
        "macos" = "8G";
    };
    imageTypes = {
        "windows" = "iso";
        "macos" = "iso";
    };
    guest = {
        "windows" = "windows";
        "macos" = "macos";
    };
    osSpecifics = {
        "windows" = {
            tpm = "on";
            secureboot = "off";
        };
        _macos = {
            "monterey" = {
                macos_release = "monterey";
                cpu_cores = 2;
            };
        };
        macos = release: osSpecifics._macos.${release} or {
            macos_release = release;
        };
    };
    releases = {
        "windows" = ["10" "11"];
        "macos" = [
            "mojave"
            "catalina"
            "big-sur"
            "monterey"
            "ventura"
            "sonoma"
        ];
    };
    oses = ["windows" "macos"];
in {
    vmType = types.attrsOf (types.submodule (
        { name, config, ... }: {
            options = {
                enable = mkEnableOption name;
                os = mkOption {
                    type = types.enum oses;
                    description = ''
                        OS to use
                    '';
                };
                release = mkOption {
                    type = types.enum releases.${config.os};
                    default = builtins.head releases.${config.os};
                    description = ''
                        Release to use
                    '';
                };
                language = mkOption {
                    type = types.str;
                    default = "English (United States)";
                    description = ''
                        Language to use
                    '';
                };
                isoFile = mkOption {
                    type = types.path;
                    description = ''
                        ISO file to use
                    '';
                };
                settings = mkOption {
                    type = types.attrsOf {
                        diskSize = mkOption {
                            type = types.str;
                            default = diskSizes.${config.os} or "64G";
                            description = ''
                                Disk size to use
                            '';
                        };
                        ram = mkOption {
                            type = types.str;
                            default = ram.${config.os} or "4G";
                            description = ''
                                RAM to use
                            '';
                        };
                        imageType = mkOption {
                            type = types.enum ["img" "iso"];
                            default = imageTypes.${config.os} or "iso";
                            description = ''
                                Image type to use
                            '';
                        };
                        guest = mkOption {
                            type = types.str;
                            default = guest.${config.os} or config.os;
                            description = ''
                                Guest to use
                            '';
                        };
                        legacyBoot = mkOption {
                            type = types.bool;
                            default = false;
                            description = ''
                                Legacy boot to use
                            '';
                        };
                    };
                    description = ''
                        Settings to use
                    '';
                };
            };
        })
    );
}