{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
}:

stdenv.mkDerivation {
  pname = "ShyFox";
  version = "3.8.1"; # Adjust version as needed

  src = fetchFromGitHub {
    owner = "Naezr";
    repo = "ShyFox";
    rev = "dd4836fb6f93267de6a51489d74d83d570f0280d";
    sha256 = "sha256-7H+DU4o3Ao8qAgcYDHVScR3pDSOpdETFsEMiErCQSA8=";
  };

  # No build phase needed since we're just installing scripts
  dontBuild = true;

  installPhase = ''
    # Create necessary directories
    mkdir $out
    cp -R $src/* $out/
  '';

  meta = with lib; {
    description = "ShyFox";
    homepage = ""; # Add homepage URL
    license = licenses.mit; # Adjust license as needed
    platforms = platforms.unix;
    maintainers = with maintainers; [ ]; # Add maintainers if desired
  };
}
