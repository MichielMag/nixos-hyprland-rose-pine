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
    osReleaseLanguage = os: release: releases: {
        enable = mkEnableOption os;
        os = mkOption {
            type = types.enum ["windows" "macos"];
            default = os;
            description = ''
                OS to use
            '';
        };
        release = mkOption {
            type = types.enum releases;
            default = release;
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
        options = {
            diskSize = mkOption {
                type = types.str;
                default = diskSizes.${os} or "64G";
                description = ''
                    Disk size to use
                '';
            };
            ram = mkOption {
                type = types.str;
                default = ram.${os} or "4G";
                description = ''
                    RAM to use
                '';
            };
            imageType = mkOption {
                type = types.enum ["img" "iso"];
                default = imageTypes.${os} or "iso";
                description = ''
                    Image type to use
                '';
            };
            guest = mkOption {
                type = types.str;
                default = guest.${os} or os;
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
    };
in {
    vmType = 
        types.attrsOf (types.submodule (
            { name, config, ... }: {
                options = types.either osReleaseLanguage "windows" "11" ["10" "11"]
                    osReleaseLanguage "macos" "mojave" [
                        "mojave"
                        "catalina" 
                        "big-sur"
                        "monterey"
                        "ventura"
                        "sonoma"
                    ];
            }
        ));
}