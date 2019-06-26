# syntax=docker/dockerfile:1.0-experimental

FROM alpine:latest

RUN apk update && apk add --no-cache dumb-init

COPY backup.sh /

ENTRYPOINT [ "/usr/bin/dumb-init", "--" ]

CMD [ "/bin/sh" ]

# END
