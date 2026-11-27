{
  description = "Powerful yet simple to use screenshot software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs@{
      flake-parts,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      perSystem =
        {
          pkgs,
          lib,
          ...
        }:
        let
          qtcolorwidgets = pkgs.fetchFromGitLab {
            owner = "mattbas";
            repo = "Qt-Color-Widgets";
            rev = "3.0.0";
            hash = "sha256-77G1NU7079pvqhQnSTmMdkd2g1R2hoJxn183WcsWq8c=";
          };

          kdsingleapplication = pkgs.fetchFromGitHub {
            owner = "KDAB";
            repo = "KDSingleApplication";
            rev = "v1.2.0";
            hash = "sha256-rglt89Gw6OHXXVOEwf0TxezDzyHEvWepeGeup7fBlLs=";
          };

          enableWlrSupport = true;

          # Build time
          nativeBuildInputs =
            with pkgs;
            [
              cmake
              qt6.qttools
              qt6.wrapQtAppsHook
              makeBinaryWrapper
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [
              imagemagick
              libicns
            ];

          # Run time
          buildInputs = with pkgs; [
            qt6.qtbase
            qt6.qtsvg
            qt6.qtwayland
            kdePackages.kguiaddons
          ];

          tildeshot = pkgs.stdenv.mkDerivation {
            pname = "tildeshot";
            version = "dev";

            src = ./.;

            inherit nativeBuildInputs;
            inherit buildInputs;

            preConfigure = ''
              mkdir -p build/_deps
              cp -r ${qtcolorwidgets} build/_deps/qtcolorwidgets-src
              cp -r ${kdsingleapplication} build/_deps/kdsingleapplication-src
              chmod -R +w build/_deps
            '';

            cmakeFlags = [
              (lib.cmakeBool "DISABLE_UPDATE_CHECKER" true)
              (lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
              (lib.cmakeBool "USE_WAYLAND_GRIM" enableWlrSupport)
              "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
              "-DFETCHCONTENT_SOURCE_DIR_QTCOLORWIDGETS=${qtcolorwidgets}"
              "-DFETCHCONTENT_SOURCE_DIR_KDSINGLEAPPLICATION=${kdsingleapplication}"
            ];

            dontWrapQtApps = true;

            postFixup = ''
              wrapProgram $out/bin/tildeshot \
                ${lib.optionalString enableWlrSupport "--prefix PATH : ${lib.makeBinPath [ pkgs.grim ]}"} \
                ''${qtWrapperArgs[@]}
            '';

            meta = {
              description = "Powerful yet simple to use screenshot software";
              homepage = "https://github.com/poweruserz/tildeshot";
              license = pkgs.lib.licenses.gpl3Only;
              maintainers = [ "tildeshot-org" ];
              platforms = pkgs.lib.platforms.unix ++ pkgs.lib.platforms.darwin;
              mainProgram = "tildeshot";
            };
          };
        in
        {
          packages = {
            default = tildeshot;
            inherit tildeshot;
          };

          devShells.default = pkgs.mkShell {
            name = "tildeshot-dev";

            inputsFrom = [ tildeshot ];

            buildInputs = with pkgs; [
              gdb
            ];
          };

          treefmt = {
            programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
            programs.nixfmt.package = pkgs.nixfmt-rfc-style;
          };
        };
    };
}
