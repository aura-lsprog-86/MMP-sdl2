#!/bin/sh

echo "Installing toolchain..."

wget --progress=dot:mega -O - https://github.com/steward-fu/website/releases/download/miyoo-mini/mini_toolchain-v1.0.tar.gz \
  | bsdtar -xf- -C /opt mini/ prebuilt/ \
  && ls -1 /opt | grep -E '^(mini|prebuilt)$'

echo "Toolchain installed!"

echo "Downloading sources..."

wget --progress=dot:mega -O - https://github.com/steward-fu/sdl2/archive/refs/heads/master.zip \
  | bsdtar -xf- -C . sdl2-master/ \
  && ls -1 . | grep -E 'sdl2-master$'

echo "Sources downloaded!"
