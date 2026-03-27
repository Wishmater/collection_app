{ pkgs ? import <nixpkgs> { } }:

let
  build = import ./build.nix { inherit pkgs; };
  libPath = pkgs.lib.makeLibraryPath (with pkgs; [

    # sqflite / sqlite3 dependencies
    sqlite

    # video_players / fvp dependencies
    ffmpeg
    libpulseaudio
    alsa-lib
    lz4
    libGL
    libx11
    libgbm
    libdrm

  ]);

in pkgs.mkShell {

  # Inherits all buildInputs/nativeBuildInputs from build.nix
  inputsFrom = [ build ];

  # Add other packages needed for dev, but not for build
  buildInputs = with pkgs; [

    jq
    yq

    flutter

    cmake
    clang

    pkg-config
    gtk3
    libsysprof-capture
    pcre2
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    xorg.libXdmcp
    lerc
    libxkbcommon
    libepoxy
    xorg.libXtst

    # sqflite / sqlite3 dependencies
    sqlite

    # video_players / fvp dependencies
    ffmpeg
    libpulseaudio
    alsa-lib
    lz4
    libGL
    libx11
    libgbm
    libdrm

  ];

  NIX_LD_LIBRARY_PATH = libPath;
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libPath}"
  '';

}
