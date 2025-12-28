{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs
    , ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
      };
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk17
        ];

        shellHook = ''
          echo "Beggining Minecraft server..."
          echo "Remember to have oppened the specified ports in configuration.properties and your IP matches it."
          java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.2.0/unix_args.txt nogui "$@"
        '';

        SHELL = "${pkgs.zsh}/bin/zsh";

        JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
      };

    };
}
