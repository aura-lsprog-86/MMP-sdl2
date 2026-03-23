#!/bin/bash
set -euo pipefail

# Build SDL2 dependencies for MM(P)
# Instructions provided in: https://github.com/Luspin/sdl2-MMP?tab=readme-ov-file#cross-build-sdl2-dependency-libraries

# Build the provided SDL2 dependencies
cd sdl2-master/sdl2/dependency

for archive in *.tar.gz; do
  echo "Extracting: $archive"
  tar -xf "$archive"
done

source /app/setup-env.sh

find . -type d -maxdepth 1

# Build SDL2_* dependencies (leveraging Autotools)
for dir in \
  SDL2_net-2.2.0 \
  SDL2_gfx \
  SDL2_image-2.8.1 \
  SDL2_mixer-2.6.3 \
  SDL2_ttf-2.20.2
do
  echo "=== Building $dir ==="

  cd "$dir"
  make distclean >/dev/null 2>&1 || true

  # Configure Arguments
  cfg_args=(--host="$TARGET" --prefix="$PREFIX")

  # Specifically for SDL2_gfx: avoid x86/MMX checks when cross-compiling
  if [[ "$dir" == SDL2_gfx* ]]; then
    cfg_args+=(--disable-mmx)
  fi

  ./configure "${cfg_args[@]}"
  make -j"$(nproc)" V=0
  make install
  cd ..
done

# A different approach is required for the JSON-C dependency
cd json-c-0.15

rm -rf build-arm

cmake -S . -B build-arm \
  -DCMAKE_SYSTEM_NAME=Linux \
  -DCMAKE_C_COMPILER="$CC" \
  -DCMAKE_AR="$AR" \
  -DCMAKE_RANLIB="$RANLIB" \
  -DCMAKE_STRIP="$STRIP" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_STATIC_LIBS=OFF

cmake --build build-arm -j"$(nproc)"
cmake --install build-arm

# Take note of where .so libraries are installed
find "$PREFIX/lib" -maxdepth 1 -type f -name '*.so*' -o -name '*.a' | sort
# - Expecting:
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_gfx-1.0.so.0.0.2
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_gfx.a
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_image-2.0.so.0.800.1
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_image.a
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_mixer-2.0.so.0.600.3
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_mixer.a
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_net-2.0.so.0.200.0
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_net.a
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_ttf-2.0.so.0.2000.2
# /app/sdl2-master/sdl2/deps-out/lib/libSDL2_ttf.a
# /app/sdl2-master/sdl2/deps-out/lib/libjson-c.so.5.1.0

cd ../../../..
