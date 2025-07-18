# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
  # GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000

  # :: FOREIGN IMAGES
  FROM 11notes/util AS util


# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: FILE-SYSTEM
  FROM scratch AS build
  ARG TARGETPLATFORM \
      TARGETOS \
      TARGETARCH \
      TARGETVARIANT \
      APP_IMAGE \
      APP_NAME \
      APP_VERSION \
      APP_ROOT \
      APP_UID \
      APP_GID \
      APP_NO_CACHE

  ADD alpine-minirootfs-${APP_VERSION}-${TARGETARCH}${TARGETVARIANT}.tar.gz /
  COPY --from=util / /
  COPY ./rootfs /

  USER root
  RUN set -ex; \
    apk --no-cache --update --repository https://dl-cdn.alpinelinux.org/alpine/edge/main add \
      ca-certificates \
      curl \
      tzdata; \
    apk --no-cache --update --repository https://dl-cdn.alpinelinux.org/alpine/edge/community add \
      shadow \
      tini; \
    apk --no-cache --update upgrade; \
    addgroup --gid ${APP_GID} -S docker; \
    adduser --uid ${APP_UID} -D -S -h ${APP_ROOT} -s /sbin/nologin -G docker docker; \
    chmod +x -R /usr/local/bin;

    
# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: HEADER
  FROM scratch

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: multi-stage
    COPY --from=build / /

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]