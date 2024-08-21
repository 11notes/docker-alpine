# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Build
  FROM --platform=linux/arm64 arm64v8/alpine:3.20.2 as build
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  ENV MIMALLOC_VERSION=v2.1.7

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
  FROM --platform=linux/arm64 arm64v8/alpine:3.20.2
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=build /mimalloc/build/*.so.* /lib/
  ENV LD_PRELOAD=/lib/libmimalloc.so
  ENV MIMALLOC_LARGE_OS_PAGES=1
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache --update add \
        curl \
        tzdata \
        shadow; \
      apk --no-cache --update upgrade;
      
    RUN set -ex; \
      ln -s /lib/libmimalloc.so.* /lib/libmimalloc.so || echo "libmimalloc.so linked"

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker