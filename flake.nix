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
      system = "x86_64-linux"
      inherit (nixpkgs) lib;

      project = pyproject-nix.lib.project.loadPyproject {
        projectRoot = ./.;
      };

      pkgs = nixpkgs.legacyPackages.${system};
      python = pkgs.python3;

    in
    {
      # Build our package using `buildPythonPackage
      packages.${system}.default =
        let
          # Returns an attribute set that can be passed to `buildPythonPackage`.
          attrs = project.renderers.buildPythonPackage { inherit python; };
        in
        # Pass attributes to buildPythonPackage.
        # Here is a good spot to add on any missing or custom attributes.
        python.pkgs.buildPythonPackage (attrs // {
          env.CUSTOM_ENVVAR = "hello";
        });
    };
}
