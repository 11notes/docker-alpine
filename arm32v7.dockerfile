# :: Builder
  FROM alpine AS qemu
  ENV QEMU_URL=https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
  RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . && mv qemu-3.0.0+resin-arm/qemu-arm-static .

# :: Header
  FROM arm32v7/alpine:3.17
  COPY --from=qemu qemu-arm-static /usr/bin

# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --update --no-cache add \
        tzdata \
        shadow; \
      apk update; \
      apk upgrade;