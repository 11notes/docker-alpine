# :: Util
  FROM 11notes/util AS util

# :: Mimalloc
  FROM 11notes/mimalloc:2.2.2 AS mimalloc

# :: Header
  FROM scratch

  # :: arguments
    ARG TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT

  # :: environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

    ENV LD_PRELOAD=/usr/lib/libmimalloc.so \
        MIMALLOC_LARGE_OS_PAGES=1

  # :: multi-stage
    ADD alpine-minirootfs-${APP_VERSION}-${TARGETARCH}${TARGETVARIANT}.tar.gz /
    COPY --from=util /usr/local/bin/ /usr/local/bin
    COPY --from=mimalloc /usr/lib/libmimalloc.so /usr/lib/

# :: Run
  USER root

  # :: update image
    ARG APP_NO_CACHE
    RUN set -ex; \
      apk --no-cache --update --repository https://dl-cdn.alpinelinux.org/alpine/edge/main add \
        ca-certificates \
        curl \
        tzdata; \
      apk --no-cache --update --repository https://dl-cdn.alpinelinux.org/alpine/edge/community add \
        shadow \
        tini; \
      apk --no-cache --update upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h ${APP_ROOT} -s /sbin/nologin -G docker docker;

  # :: copy filesystem changes and set correct permissions
    COPY ./rootfs /
    RUN set -ex; \
      chmod +x -R /usr/local/bin;

# :: Start
  USER docker
  ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]