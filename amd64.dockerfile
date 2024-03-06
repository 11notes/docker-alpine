# :: Build
  FROM 11notes/apk-build:stable as build
  ENV APK_NAME="mimalloc"
  COPY ./build /src
  RUN set -ex; \
    apk-build

# :: Header
  FROM alpine:3.19.1
  COPY --from=build /apk /apk/custom
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow; \
      apk --no-cache --allow-untrusted --repository /apk/custom add \
        mimalloc; \
      apk --no-cache upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker