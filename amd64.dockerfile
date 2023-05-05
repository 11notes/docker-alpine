# :: Header
  FROM alpine:3.17
  
# :: Run
  USER root

# :: prepare
  RUN set -ex; \
    apk --update --no-cache add \
      tzdata \
      shadow; \
    apk update; \
    apk upgrade;