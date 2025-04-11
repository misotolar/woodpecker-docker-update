FROM --platform=$BUILDPLATFORM misotolar/alpine:3.21.3

LABEL org.opencontainers.image.url="https://github.com/misotolar/woodpecker-docker-update"
LABEL org.opencontainers.image.description="Woodpecker plugin for update Docker Hub description and overview"
LABEL org.opencontainers.image.authors="Michal Sotolar <michal@sotolar.com>"

RUN set -ex; \
    apk add --no-cache --upgrade \
        bash \
        curl \
        jq

COPY resources/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
