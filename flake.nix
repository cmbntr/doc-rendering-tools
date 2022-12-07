{
  description = "documentation rendering tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs }: 
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      {
        packages.x86_64-linux = {

          default = pkgs.buildEnv {
            name = "doc-rendering-tools";
            paths = [
              pkgs.gpp
              pkgs.pandoc
              pkgs.pandoc-include
              pkgs.pandoc-lua-filters
              pkgs.pandoc-imagine
              pkgs.graphviz-nox
              pkgs.texlive.combined.scheme-small
            ];
          };
        };

        container = 
          let 
            baseContainer = let
              dt = pkgs.dockerTools;
              inherit (dt) buildImage binSh usrBinEnv fakeNss caCertificates;
            in
              buildImage {
                name = "base-img";
                copyToRoot = [
                  pkgs.coreutils
                  binSh
                  caCertificates
                  fakeNss
                ];
              };
          in
            pkgs.dockerTools.buildImage {
              fromImage = baseContainer;
              name = "doc-rendering-tools";
              tag = "latest";
              copyToRoot =  self.packages.x86_64-linux.default;
              config = {
                Cmd = [ "/bin/sh" ];
                WorkingDir = "/tmp";
                Env = [
                  "HOME=/tmp"
                ];
              };
            };

      };
}
