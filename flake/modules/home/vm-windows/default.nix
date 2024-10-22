{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.vm-windows;
  quickemu-git = pkgs.fetchFromGitHub {
    owner = "MichielMag";
    repo = "quickemu";
    rev = "60741d355eca887624889a21e876daf3f758bbcc";
    sha256 = "sha256-luFbOyvXCyJXGKefSJ2aLPacDuKvvNv1kvqlV9ndfrw=";
  };
  quickemu = pkgs.callPackage (import "${quickemu-git}/package.nix") { };
  qemu-system-x86_64-uefi = (
    pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      ${pkgs.qemu}/bin/qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    ''
  );
in
{
  options.modules.vm-windows = {
    enable = mkEnableOption "vm-windows";
  };

  config = mkIf cfg.enable {

    home.packages = [
      pkgs.qemu_full
      quickemu
      qemu-system-x86_64-uefi
    ];

    home.file.".source/quickemu" = {
      source = quickemu-git;
      recursive = true;
      target = ".source/quickemu";
    };
  };
}
