# Build image
FROM alpine:3.14 as build

ARG VERSION

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
ENV GO111MODULE=on

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.14/community" >> /etc/apk/repositories && \
    apk add --no-cache nodejs-current npm go make g++ git && \
    go install std && \
    go get -u github.com/go-bindata/go-bindata/... && \
    npm install -g less less-plugin-clean-css

RUN mkdir -p /go/src/github.com/writefreely/writefreely/ && \
    git clone https://github.com/writefreely/writefreely.git /go/src/github.com/writefreely/writefreely/ -b $VERSION

WORKDIR /go/src/github.com/writefreely/writefreely/

RUN make build && \
    make ui

RUN mkdir /stage && \
    cp -R /go/bin \
      /go/src/github.com/writefreely/writefreely/templates \
      /go/src/github.com/writefreely/writefreely/static \
      /go/src/github.com/writefreely/writefreely/pages \
      /go/src/github.com/writefreely/writefreely/keys \
      /go/src/github.com/writefreely/writefreely/cmd \
      /stage && \
      mv /stage/cmd/writefreely/writefreely /stage

# Final image
FROM alpine:3.14

RUN apk add --no-cache openssl ca-certificates

COPY --from=build --chown=daemon:daemon /stage /writefreely
COPY bin/run.sh /writefreely/

WORKDIR /writefreely
VOLUME /data
VOLUME /config
EXPOSE 8080
USER daemon

ENTRYPOINT ["/writefreely/run.sh"]
