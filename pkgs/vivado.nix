{
  stdenv,
  lib,
  buildFHSEnv,
  runCommand,
  requireFile,
  writeShellScript,
}: let
  configFile = import ./config.nix {
    product = "Vivado";
    edition = "Vivado ML Enterprise";
    destination = "/opt/Xilinx";
  };

  installEnv = buildFHSEnv {
    name = "xilinx-install-env";
    targetPkgs = pkgs:
      with pkgs; [
        libxcrypt-legacy
        zlib
        lsb-release
      ];

    extraBwrapArgs = [
      "--bind $out/opt /opt"
    ];
  };

  vivadoInstalled = stdenv.mkDerivation {
    name = "Vivado";
    version = "2024.2_1113_1001";

    src = import ./installer.nix {inherit runCommand requireFile;};

    phases = ["configurePhase" "installPhase"];

    nativeBuildInputs = [
      installEnv
    ];

    configurePhase = ''
      runHook preConfigure

      export HOME="$PWD"
      cat > $PWD/install_config.txt <<EOF
      ${configFile}
      EOF
      cat $PWD/install_config.txt

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall
      cat $PWD/install_config.txt

      mkdir -p $out/opt/

      xilinx-install-env $src/FPGAs_AdaptiveSoCs_Unified_2024.2_1113_1001/xsetup --agree 3rdPartyEULA,XilinxEULA --batch Install -c $PWD/install_config.txt

      runHook postInstall
    '';
  };

  vivadoWrapped = buildFHSEnv {
    name = "vivado";
    targetPkgs = pkgs:
      with pkgs; let
        ncurses' = ncurses5.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ ["--with-termlib"];
          postFixup = "";
        });
      in [
        ncurses'
        (ncurses'.override {unicodeSupport = false;})
        stdenv.cc.cc
        stdenv.cc.cc.lib
        zlib
        glibc
        glibc.dev
        glibc.static
        gcc

        fontconfig
        freetype
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXtst
        xorg.libXi
        libxcrypt-legacy

        graphviz
        nettools
        unzip

        ocl-icd
        opencl-headers
        opencl-clhpp

        libyaml
        libidn
        binutils
        lsb-release

        vivadoInstalled
      ];

    extraBwrapArgs = [
      "--ro-bind ${vivadoInstalled}/opt /opt"
    ];

    profile = ''
      export LIBRARY_PATH=/lib:/lib64
    '';

  };
in
  vivadoWrapped
