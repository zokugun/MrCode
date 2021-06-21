#!/usr/bin/env bash

source "vscodium/icons/build_icons.sh"

SRC_PREFIX="src/"
VSCODE_PREFIX="vscodium/"

build_darwin_types
build_darwin_main
build_win32
