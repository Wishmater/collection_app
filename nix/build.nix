{ pkgs ? import <nixpkgs> }:

pkgs.flutter.buildFlutterApplication rec {

  pname = "collection_app";
  version = "0.0.2+2";

  src = ./..;

  # autoPubspecLock = src + "/pubspec.lock";
  pubspecLock = pkgs.lib.importJSON (src + "/pubspec.lock.json");
  gitHashes = pkgs.lib.importJSON (src + "/pubspecGitHashes.json");

  # TODO: 1 test adding sqlite to release build
  nativeBuildInputs = with pkgs;
    [

    ];

}
