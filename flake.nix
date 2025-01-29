{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/357cd3dfdb8993af11268d755d53357720675e66";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ ];
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [ ];
        };
      in
      {
        devShell =
          with pkgs;
          with pkgs.darwin.apple_sdk.frameworks;
          mkShell {
            buildInputs = [
              # JavaScript
              nodejs_22
              yarn

              # elmPackages.elm
              # elmPackages.elm-format
              # elmPackages.elm-test

              # Apple
              CoreServices
              ApplicationServices
              OpenGL
              CoreVideo
              Carbon
              AppKit
              WebKit
            ] ++ (lib.optionals stdenv.isDarwin
              (with pkgs.darwin.apple_sdk.frameworks;
              [
                SystemConfiguration
                CoreServices
                CoreBluetooth
              ])
            );

            shellHook = ''
              export PATH=$PATH:node_modules/.bin/
            '';
          };
      });
}
