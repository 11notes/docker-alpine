# :: Header
    FROM alpine:3.16

# :: Run
    USER root

    # :: prepare
        RUN apk --update --no-cache add \
                shadow