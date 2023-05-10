# :: Header
  FROM alpine:3.17
  
# :: Run
  USER root

  # :: update image
    RUN set -ex; \
      apk --update --no-cache add \
        tzdata \
        shadow; \
      apk update; \
      apk upgrade;