{
  description = "Selenium with Firefox Web Driver";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
  };

  outputs =
    { nixpkgs
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
      };

    in

    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          python313Packages.selenium
          geckodriver
        ];

        shellHook = ''
          echo "Selenium with firefox support"
        '';

        SHELL = "${pkgs.zsh}/bin/zsh";
      };
    };

}
