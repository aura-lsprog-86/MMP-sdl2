#!/bin/bash
set -euo pipefail

# Compilation Environment Variables
export TOOLCHAIN=/opt/mini/bin
export PATH="$TOOLCHAIN:$PATH"

# Target triplet for the Miyoo Mini toolchain
export TARGET=arm-linux-gnueabihf

# Path where all cross-built dependencies are placed
export PREFIX="/app/sdl2-master/sdl2/deps-out"
mkdir -p "$PREFIX"

# Toolchain binaries
export CC="${TARGET}-gcc"
export CXX="${TARGET}-g++"
export AR="${TARGET}-ar"
export RANLIB="${TARGET}-ranlib"
export STRIP="${TARGET}-strip"

# Confirm Miyoo Mini toolchain is being used
command -v "$CC" >/dev/null || { echo "ERROR: $CC not found on PATH"; exit 1; }
"$CC" --version | head -n 1

# 'pkg-config' paths for dependency discovery
export PKG_CONFIG=pkg-config
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig"

# Common include/lib search paths
export CPPFLAGS="-I$PREFIX/include"
export LDFLAGS="-L$PREFIX/lib"
