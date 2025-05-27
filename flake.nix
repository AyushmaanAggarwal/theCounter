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
      attrs = project.renderers.buildPythonPackage { inherit python; };

    in
    {
      # Build our package using `buildPythonPackage
      packages.${system}.default =
        # Pass attributes to buildPythonPackage.
        # Here is a good spot to add on any missing or custom attributes.
        python.pkgs.buildPythonPackage (attrs // {
          dependencies = [ 
            pkgs.python312Packages.flask
          ];
          env.CUSTOM_ENVVAR = "hello";
        });

        
        systemd.services.gunicorn = {
          enable = true;
          description = "gunicorn daemon";
          # In NixOS, you refer to dependencies by name without the suffix.
          requires = [ "gunicorn.socket" ];
          after = [ "network.target" ];
          serviceConfig = {
            Type = "notify";
            NotifyAccess = "main";
            User = "counter";
            Group = "counter";
            DynamicUser = true;
            RuntimeDirectory = "gunicorn";
            WorkingDirectory = "/home/proxmox/theCounter";
            ExecStart = "/usr/bin/gunicorn applicationname.wsgi";
            ExecReload = "/bin/kill -s HUP $MAINPID";
            KillMode = "mixed";
            TimeoutStopSec = "5";
            PrivateTmp = true;
            ProtectSystem = "strict";
          };
          wantedBy = [ "multi-user.target" ];
        };
      
        # Define the gunicorn socket unit
        systemd.sockets.gunicorn = {
          enable = true;
          description = "gunicorn socket";
          # Listen on a Unix socket
          listenStream = "/run/gunicorn.sock";
          socketConfig = {
            SocketUser = "www-data";
            SocketGroup = "www-data";
            SocketMode = "0660";
          };
          wantedBy = [ "sockets.target" ];
        };
    };
}
