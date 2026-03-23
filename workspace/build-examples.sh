#!/bin/bash
set -euo pipefail

# Script that compiles steward-fu's SDL2 examples
# Instructions based from: https://github.com/Luspin/sdl2-MMP?tab=readme-ov-file#build--stage-sdl2-examples-for-the-miyoo

source /app/setup-env.sh

bsdtar -xf examples.zip -C . examples/

cd examples/

SDL2_ROOT=/app/sdl2-master

# Copy the newly built SDL2 and related libraries to the "libs" folder
# 1) Core SDL2 library
cp -av "$SDL2_ROOT"/sdl2/build/.libs/libSDL2-2.0.so.0* ./libs/

# 2) SwiftShader runtime
cp -av "$SDL2_ROOT"/swiftshader/build/libEGL.so    ./libs/
cp -av "$SDL2_ROOT"/swiftshader/build/libGLESv2.so ./libs/
# Provide the SONAME expected by some loaders/apps (symlink locally)
ln -sf libGLESv2.so ./libs/libGLESv2.so.2

# 3) SDL2 dependency libraries
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libjson-c.so.5*            ./libs/
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libSDL2_gfx-1.0.so.0*      ./libs/
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libSDL2_net-2.0.so.0*      ./libs/
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libSDL2_image-2.0.so.0*    ./libs/
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libSDL2_ttf-2.0.so.0*      ./libs/
cp -av "$SDL2_ROOT"/sdl2/deps-out/lib/libSDL2_mixer-2.0.so.0*    ./libs/

# Clean, then compile all example files in parallel
make clean
make -j"$(nproc)"

cd ..
