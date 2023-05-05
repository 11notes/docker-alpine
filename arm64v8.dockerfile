# :: Builder
  FROM alpine AS multi-arch
  ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
  RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . && mv qemu-3.0.0+resin-aarch64/qemu-aarch64-static .

# :: Header
  FROM arm64v8/alpine:3.17
  COPY --from=multi-arch qemu-aarch64-static /usr/bin

# :: Run
  USER root

# :: prepare
  RUN set -ex; \
    apk --update --no-cache add \
      tzdata \
      shadow; \
    apk update; \
    apk upgrade;