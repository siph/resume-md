{
  description = "Build you resume with markdown";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [ "qtwebkit-5.212.0-alpha4" ];
          };
        };
        buildInputs = with pkgs; [
          pandoc
          wkhtmltopdf-bin
        ];
      in with pkgs; {
        packages = {
          default = stdenv.mkDerivation {
            inherit buildInputs;
            name = "resume_md";
            src = ./.;
            buildPhase = ''
              pandoc resume.md \
              -t html -f markdown \
              -c style.css --self-contained \
              -o resume.html

              wkhtmltopdf --enable-local-file-access \
              resume.html \
              resume.pdf
            '';
            installPhase = ''
              mkdir -p $out/resume
              cp resume.* $out/resume/
            '';
          };
        };
        devShell = mkShell {
          inherit buildInputs;
        };
      });
}

