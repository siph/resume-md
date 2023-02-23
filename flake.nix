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
      in rec {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              pandoc
              wkhtmltopdf-bin
            ];
          };
      });
}

