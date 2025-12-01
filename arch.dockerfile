# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
# GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000

# :: FOREIGN IMAGES
  FROM 11notes/util AS util
  FROM 11notes/distroless AS distroless
  FROM 11notes/distroless:tini AS distroless-tini


# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
# :: MINIROOTFS
  FROM alpine/git AS minirootfs
  ARG APP_VERSION \
      TARGETARCH \
      TARGETVARIANT
  COPY --from=util / /

  RUN set -ex; \
    apk --update --no-cache add \
      tar \
      pv;

  RUN set -ex; \
    mkdir -p /distro; \
    case "${TARGETARCH}${TARGETVARIANT}" in \
      "amd64")export TARGETARCH="x86_64";; \
      "arm64")export TARGETARCH="aarch64";; \
    esac; \
    export VERSION=$(echo ${APP_VERSION} | awk -F '.' '{print $1}').$(echo ${APP_VERSION} | awk -F '.' '{print $2}'); \
    eleven git clone alpinelinux/docker-alpine v${VERSION}; \
    pv /git/docker-alpine/${TARGETARCH}${TARGETVARIANT}/alpine-minirootfs-${APP_VERSION}-${TARGETARCH}${TARGETVARIANT}.tar.gz | tar xz -C /distro;


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

  COPY --from=minirootfs /distro/ /
  COPY --from=util / /
  COPY --from=distroless / /
  COPY --from=distroless-tini / /
  COPY ./rootfs /

  RUN set -ex; \
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
  ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]