{pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "TLAToolBox-${version}";
  version = "1.5.2";

  src = fetchurl {
    url = "https://tla.msr-inria.inria.fr/tlatoolbox/products/TLAToolbox-1.5.2-linux.gtk.x86_64.zip";
    sha256 = "1xsqw34qy341mgfg57fcp0skm8rv4sqzi7qb442vn21nhhwmmxdk";
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
