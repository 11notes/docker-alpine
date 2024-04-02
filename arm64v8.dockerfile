# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Build
  FROM arm64v8/alpine:3.19.1 as build
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  ENV MIMALLOC_VERSION=v2.1.2

  RUN set -ex; \
    apk add --no-cache \
      curl \
      wget \
      unzip \
      build-base \
      linux-headers \
      make \
      cmake \
      g++ \
      git; \
    git clone https://github.com/microsoft/mimalloc.git; \
    cd /mimalloc; \
    git checkout ${MIMALLOC_VERSION}; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j$(nproc); \
    make install

# :: Header
  FROM arm64v8/alpine:3.19.1
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=build /mimalloc/build/*.so.* /lib/
  ENV LD_PRELOAD=/lib/libmimalloc.so
  ENV MIMALLOC_LARGE_OS_PAGES=1
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow; \
      apk --no-cache upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker