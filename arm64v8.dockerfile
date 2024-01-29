# :: Arch
  FROM multiarch/qemu-user-static:x86_64-aarch64 as qemu

# :: Header
  FROM arm64v8/alpine:3.19.1
  COPY --from=qemu /usr/bin/qemu-aarch64-static /usr/bin
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --no-cache add \
        curl \
        tzdata \
        shadow; \
      apk --no-cache upgrade;

  # :: create user
    RUN set -ex; \
      addgroup --gid 1000 -S docker; \
      adduser --uid 1000 -D -S -h / -s /sbin/nologin -G docker docker;

  USER docker