FROM ubuntu:24.04

RUN apt-get update && apt-get upgrade -y --no-install-recommends \
  build-essential \
  cmake \
  ninja-build \
  autoconf \
  automake \
  libtool \
  pkg-config \
  gettext \
  m4 \
  perl \
  python3 \
  unzip \
  patch \
  wget \
  libarchive-tools \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY 01-prepare-deps.sh .
RUN chmod +x 01-prepare-deps.sh \
  && ./01-prepare-deps.sh
  
COPY 02-build-sources.sh .
RUN chmod +x 02-build-sources.sh \
  && ./02-build-sources.sh

COPY 03-crossbuild-deps.sh .
RUN chmod +x 03-crossbuild-deps.sh \
  && ./03-crossbuild-deps.sh

CMD ['sh']
