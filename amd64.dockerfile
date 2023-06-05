# :: Header
  FROM alpine:3.18
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --update --no-cache add \
        curl \
        tzdata \
        shadow; \
      apk update; \
      apk upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker