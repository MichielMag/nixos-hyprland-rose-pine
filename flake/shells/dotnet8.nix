# save this as shell.nix
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    dotnet-sdk_8
  ];
}
