# :: Build
  FROM alpine:3.19.1 as build
  ENV BUILD_VERSION=v3.19.1

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
    git checkout ${BUILD_VERSION}; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j$(nproc); \
    make install

# :: Header
  FROM alpine:3.19.1
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
      apk --no-cache upgrade; \
      ln -s /lib/libmimalloc.so.* /lib/libmimalloc.so;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker