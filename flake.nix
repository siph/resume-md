{
  description = "Build you resume with markdown";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [ "openssl-1.1.1v" ];
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

