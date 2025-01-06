# :: QEMU
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Util
  FROM alpine as util

  RUN set -ex; \
    apk add --no-cache \
      git; \
    git clone -b stable https://github.com/11notes/docker-util.git;

# :: Build
  FROM --platform=linux/arm64 alpine as build
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
    git clone https://github.com/microsoft/mimalloc.git -b ${MIMALLOC_VERSION}; \
    cd /mimalloc; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j$(nproc); \
    make install

# :: Image
  FROM scratch
  ADD alpine-minirootfs-3.21.0-aarch64.tar.gz /
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  COPY --from=build /mimalloc/build/*.so.* /lib/
  COPY --from=util /docker-util/src /usr/local/bin
  ENV LD_PRELOAD=/lib/libmimalloc.so
  ENV MIMALLOC_LARGE_OS_PAGES=1

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache --update add \
        ca-certificates \
        tini \
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

  # :: copy root filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin; \
      chown -R 1000:1000 /usr/local/bin;

# :: Start
  USER docker
  ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]