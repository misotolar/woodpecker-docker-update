FROM --platform=$BUILDPLATFORM alpine:3.19.1

LABEL maintainer="michal@sotolar.com"

RUN set -ex; \
    apk add --no-cache --upgrade \
        bash \
        curl \
        jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
