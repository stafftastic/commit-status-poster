{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, nixpkgs, systems }:
  let
    version = "v1.0.1";
    lib = nixpkgs.lib;
    eachSystem = lib.genAttrs (import systems);
    pkgsFor = eachSystem (system: nixpkgs.legacyPackages.${system});
  in {
    devShell = eachSystem(system: pkgsFor.${system}.mkShell {
      buildInputs = with pkgsFor.${system}; [ go ];
    });
    packages = eachSystem (system:
    let
      pkgs = pkgsFor.${system};
    in {
      default = pkgs.buildGoModule {
        pname = "commit-status-poster";
        version = version;
        src = ./.;
        vendorHash = "sha256-e3l8lZqbjb7ZaUUM2MipYqilkkxI+BsVac+22OdOpz8=";
      };
      dockerImage = pkgs.dockerTools.buildImage {
        name = "commit-status-poster";
        tag = version;
        copyToRoot = pkgs.buildEnv {
          name = "commit-status-poster";
          paths = with pkgs; [
            self.packages.${system}.default
            dockerTools.caCertificates
          ];
        };
        config = {
          Entrypoint = [ "/bin/commit-status-poster" ];
        };
      };
    });
  };
}
