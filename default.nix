{pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "TLAToolBox-${version}";
  version = "1.5.2";

  src = fetchurl {
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/products/TLAToolbox-1.5.6-linux.gtk.x86_64.zip";
    sha256 = "1b5sf4d7sv0x1hg4f1if3q7wzsi09dr8fv71qfagj8m25zrh3lvj";
  };

  buildInputs = [ patchelf unzip makeWrapper jre ];

  unpackPhase = ''
    unzip $src
  '';

  buildPhase = ''
    patchelf  --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ./toolbox/toolbox
  '';

  installPhase = ''
    mkdir -p $out
    cp -r toolbox/* $out

    wrapProgram $out/toolbox \
      --set JAVA_HOME "${jre}" \
      --prefix PATH : "${jre}/bin" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ gtk2 xorg.libXtst ]}
  '';

}
