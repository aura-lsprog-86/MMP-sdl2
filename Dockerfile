FROM ubuntu:24.04

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

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

COPY support/setup-env.sh .
RUN chmod +x setup-env.sh

COPY support/01-prepare-deps.sh .
RUN chmod +x 01-prepare-deps.sh \
  && ./01-prepare-deps.sh
  
COPY support/02-build-sources.sh .
RUN chmod +x 02-build-sources.sh \
  && ./02-build-sources.sh

COPY support/03-crossbuild-deps.sh .
RUN chmod +x 03-crossbuild-deps.sh \
  && ./03-crossbuild-deps.sh

CMD ["/bin/bash"]
