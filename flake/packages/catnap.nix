{
  stdenv,
  pkgs ? import <nixpkgs> { },
}:

stdenv.mkDerivation rec {
  pname = "catnap";
  version = "faa356a697daa2bf522d48746b30bb7af297604a";
  src = pkgs.fetchFromGitHub {
    owner = "iinsertNameHere";
    repo = "catnap";
    rev = "faa356a697daa2bf522d48746b30bb7af297604a";
    hash = "";
  };

  nativeBuildInputs = with pkgs; [
    nim
    gzip
  ];

  installPhase = ''
    mkdir -p $out/bin
    nim install -p $src
    install -Dm755 -t $out/bin ./catnap
  '';
}
