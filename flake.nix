# This file is used to run the website on the server
{
  description = "The NixOS flake for theCounter";

  inputs = {
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, pyproject-nix, ... }:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;

      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3;
      attrs-build = project.renderers.buildPythonPackage { inherit python; };
      attrs-shell = project.renderers.withPackages { inherit python; };
      pythonEnv = python.withPackages attrs-shell;

    in
    {
      devShells.${system}.default =
        pkgs.mkShell { packages = [ pythonEnv ]; };

      # packages.${system}.default = 
      #   python.pkgs.buildPythonPackage ( attrs-build );
        
    };
}
