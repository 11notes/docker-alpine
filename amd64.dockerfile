# :: Header
  FROM alpine:3.18.2
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --update --no-cache add \
        curl \
        tzdata \
        shadow;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  # :: update image binaries and empty cache
    RUN set -ex; \
      apk --no-cache --update upgrade; \
      apk cache clean;

  USER docker