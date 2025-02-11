# :: Util
  FROM 11notes/util AS util

# :: Build / mimalloc
  FROM alpine AS build
  ARG VERSION=v2.1.9

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
    git clone https://github.com/microsoft/mimalloc.git -b ${VERSION}; \
    cd /mimalloc; \
    mkdir build; \
    cd build; \
    cmake ..; \
    make -j $(nproc);

# :: Header
  FROM scratch

  # :: arguments
    ARG TARGETARCH
    ARG APP_IMAGE
    ARG APP_NAME
    ARG APP_VERSION
    ARG APP_ROOT

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE}
    ENV APP_NAME=${APP_NAME}
    ENV APP_VERSION=${APP_VERSION}
    ENV APP_ROOT=${APP_ROOT}

    ENV LD_PRELOAD=/usr/lib/libmimalloc.so
    ENV MIMALLOC_LARGE_OS_PAGES=1

  # :: multi-stage
    ADD alpine-minirootfs-${APP_VERSION}-${TARGETARCH}.tar.gz /
    COPY --from=util /usr/local/bin/ /usr/local/bin
    COPY --from=build /mimalloc/build/libmimalloc.so /usr/lib/

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

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h ${APP_ROOT} -s /sbin/nologin -G docker docker;

  # :: copy filesystem changes and set correct permissions
    COPY --chown=1000:1000 ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin;

# :: Start
  USER docker
  ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]