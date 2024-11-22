FROM --platform=$BUILDPLATFORM misotolar/alpine:3.20.3

LABEL maintainer="michal@sotolar.com"

RUN set -ex; \
    apk add --no-cache --upgrade \
        bash \
        curl \
        jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
