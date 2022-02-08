ARG ALPINE_VERSION
ARG APP_VERSION
FROM alpine:${ALPINE_VERSION} as alpine

LABEL name="nc-http-server"
LABEL description="Small netcat based http server which can be tuned on the fly"
LABEL source-repo="https://github.com/boeboe/nc-http-server"

WORKDIR /

RUN apk add --quiet --no-cache \
            bash \
            vim \
            netcat-openbsd \
            net-tools \
            bind-tools \
            jq


ADD ./entrypoint.sh /usr/local/bin
ADD ./config.json /
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV HTTP_PORT=8080
EXPOSE 8080

ENTRYPOINT ["entrypoint.sh"]
