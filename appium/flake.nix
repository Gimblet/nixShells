{
  description = "Appium server tool chain";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
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
          nodejs
          android-tools
          app2unit
          appium-inspector
        ];

        shellHook = #bash
          ''
          echo "Appium for Nix (Android)"
          
          touch ~/.npmrc
          echo "prefix = ''${HOME}/.npm-packages" > ~/.npmrc

          export PATH="''${HOME}/.npm-packages/bin:$PATH"

          npm i -g appium
          appium driver install uiautomator2

          export ANDROID_HOME="$PWD/.android-sdk"

          mkdir -p "$ANDROID_HOME/platform-tools"
          ln -sf ${pkgs.android-tools}/bin/adb "$ANDROID_HOME/platform-tools/adb"
          ln -sf ${pkgs.android-tools}/bin/fastboot "$ANDROID_HOME/platform-tools/fastboot"
  
          export PATH="$ANDROID_HOME/platform-tools:$PATH"

          app2unit appium &
          app2unit appium-inspector
        '';

        SHELL = "${pkgs.zsh}/bin/zsh";
        #PATH="~/.npm-packages/bin:$PATH";
        #ANDROID_HOME="/home/gimblet/Android/Sdk";
      };
    };

}
