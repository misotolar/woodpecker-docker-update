FROM --platform=$BUILDPLATFORM misotolar/alpine:3.21.0

LABEL maintainer="michal@sotolar.com"

RUN set -ex; \
    apk add --no-cache --upgrade \
        bash \
        curl \
        jq

COPY resources/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
