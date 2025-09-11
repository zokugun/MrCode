#!/usr/bin/env bash

SRC_PREFIX="src/"
VSCODE_PREFIX="vscodium/"

load_linux_png() {
  convert -size 2048x2048 canvas:transparent PNG32:"$1"

  rsvg-convert -w 2048 -h 2048 "icons/linux_main.svg" -o "icon_bg.png"

  composite "icon_bg.png" -gravity center -background none -colorspace sRGB "$1" "$1"

  rsvg-convert -w "1410" -h "1410" "icons/${QUALITY}/codium_cnl.svg" -o "icon_head.png"

  composite "icon_head.png" -geometry "+319+281.706" -background none -colorspace sRGB "$1" "$1"
}

load_windows_ico() {
  rsvg-convert -w 1024 -h 1024 "icons/${QUALITY}/codium_cnl.svg" -o "icon.png"

  convert "icon.png" -define icon:auto-resize=256,128,96,64,48,32,24,20,16 "$1"
}

source "./vscodium/icons/build_icons.sh"

build_darwin_main "no-template"
build_linux_main
build_windows_main

build_darwin_types "no-border"
build_windows_types

build_media
build_server
