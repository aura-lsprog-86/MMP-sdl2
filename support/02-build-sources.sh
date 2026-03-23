#!/bin/bash
set -euo pipefail

# Build SDL2 for MM(P)
# Instructions based on: https://github.com/Luspin/sdl2-MMP?tab=readme-ov-file#clone--build-steward-fusdl2

cd sdl2-master/
find . -type f -name "*.sh" -exec chmod +x {} \;

# Build steps provided by the SDL2 repo:
make -j"$(nproc)" cfg CFLAGS="-Wno-psabi" CXXFLAGS="-Wno-psabi"
# - Expecting:
# -- Build files have been written to: /app/sdl2-master/sdl2/swiftshader/build

make -j"$(nproc)" gpu CFLAGS="-Wno-psabi" CXXFLAGS="-Wno-psabi"
ls swiftshader/build/lib*
# - Expecting:
# swiftshader/build/libEGL.so  swiftshader/build/libGLESv2.so

make -j"$(nproc)" sdl2 CFLAGS="-Wno-psabi" CXXFLAGS="-Wno-psabi"
ls sdl2/build/.libs/libSDL2-2.0.so.0*
# - Expecting:
# sdl2/build/.libs/libSDL2-2.0.so.0  sdl2/build/.libs/libSDL2-2.0.so.0.18.2

cd ..
