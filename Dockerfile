FROM golang:alpine as builder
RUN apk add --update git
RUN go get github.com/txthinking/brook/cli/brook

FROM alpine:3.9

ARG TZ=America/Lima

RUN set -ex && \
    apk add --update --no-cache curl wget ca-certificates tzdata \
    && update-ca-certificates \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && rm -rf /var/cache/apk/*

# /usr/bin/brook
COPY --from=builder /go/bin /usr/bin

USER nobody
ENV ARGS="server -l :6060 -p password"
EXPOSE 6060/tcp 6060/udp

CMD /usr/bin/brook ${ARGS}
