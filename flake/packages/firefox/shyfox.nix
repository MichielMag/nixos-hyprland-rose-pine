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
    rev = "6488ff1934c184a7b81770c67f5c3b5e983152e3";
    sha256 = "0rs9bxxrw4wscf4a8yl776a8g880m5gcm75q06yx2cn3lw2b7v22";
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
