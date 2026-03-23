#!/bin/bash
set -euo pipefail

download_and_unzip() {
	URL="$1"
	OUTDIR="$2"
	
	shift
	shift
	
	FOLDERS=("$@")
	REGEX=$(IFS=\|; echo "${FOLDERS[*]}")
	
	wget --progress=dot:giga -O - "$URL" \
		| bsdtar -xf- -C "$OUTDIR" "${FOLDERS[@]/%//}" \
		&& ls -1 "$OUTDIR" \
		| grep -E "^($REGEX)$"
}

echo "Installing toolchain..."
TOOLCHAIN_FOLDERS=(mini prebuilt)
download_and_unzip "https://github.com/steward-fu/website/releases/download/miyoo-mini/mini_toolchain-v1.0.tar.gz" /opt "${TOOLCHAIN_FOLDERS[@]}"
echo "Toolchain installed!"

echo "Downloading sources..."
SRC_FOLDERS=(sdl2-master)
download_and_unzip "https://github.com/steward-fu/sdl2/archive/refs/heads/master.zip" . "${SRC_FOLDERS[@]}"
echo "Sources downloaded!"
