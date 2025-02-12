FROM 11notes/alpine:stable
# switch to root during setup
USER root
# setup your app
RUN set -ex; \
  setup your app
# add custom entrypoint to image
COPY ./entrypoint.sh /usr/local/bin
# start image as 1000:1000
USER docker