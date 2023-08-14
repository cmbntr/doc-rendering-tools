{
  description = "documentation rendering tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        drt = pkgs.buildEnv {
          name = "doc-rendering-tools";
          paths = [
            pkgs.gpp
            pkgs.pandoc
            pkgs.pandoc-include
            pkgs.pandoc-lua-filters
            pkgs.pandoc-imagine
            pkgs.mscgen
            pkgs.librsvg
            pkgs.graphviz-nox
            pkgs.graphicsmagick
            pkgs.graphicsmagick-imagemagick-compat
            pkgs.nodePackages.mermaid-cli
            pkgs.texlive.combined.scheme-small
          ];
        };

        baseContainer = let
              dt = pkgs.dockerTools;
              inherit (dt) buildImage binSh fakeNss caCertificates;
            in
              buildImage {
                name = "base-img";
                copyToRoot = [
                  binSh
                  caCertificates
                  fakeNss
                  pkgs.coreutils
                  pkgs.findutils
                  pkgs.gnugrep
                  pkgs.gnused
                  pkgs.gawk
                ];
              };
        
        packages.default = 
          pkgs.dockerTools.buildImage {
            fromImage = baseContainer;
            name = "doc-rendering-tools";
            tag = "latest";
            copyToRoot =  drt;
            config = {
              Cmd = [ "/bin/sh" ];
              WorkingDir = "/tmp";
              Env = [
                "HOME=/tmp"
              ];
            };
          };
      }
    );

}
