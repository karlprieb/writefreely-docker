# Build image
FROM alpine:3.23 as build

ARG REPOSITORY
ARG VERSION

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
ENV GO111MODULE=on

RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/v3.23/community" >> /etc/apk/repositories && \
    apk add --no-cache nodejs-current npm go make g++ git && \
    npm install -g less less-plugin-clean-css

WORKDIR /tmp

RUN git clone https://github.com/writefreely/writefreely.git

WORKDIR /tmp/writefreely

RUN go build -v -tags='sqlite' ./cmd/writefreely/

RUN cd less && \
    CSSDIR=../static/css && \
    lessc app.less --clean-css="--s1 --advanced" ${CSSDIR}/write.css && \
    lessc fonts.less --clean-css="--s1 --advanced" ${CSSDIR}/fonts.css && \
    lessc icons.less --clean-css="--s1 --advanced" ${CSSDIR}/icons.css && \
    lessc prose.less --clean-css="--s1 --advanced" ${CSSDIR}/prose.css

RUN cd prose && \
    export NODE_OPTIONS=--openssl-legacy-provider && \
    npm install && \
    npm run-script build

# Final image
FROM alpine:3.23

RUN apk add --no-cache openssl ca-certificates

COPY --from=build /tmp/writefreely /writefreely
COPY bin/run.sh /writefreely/

WORKDIR /writefreely
VOLUME /data
VOLUME /config
EXPOSE 8080

ENTRYPOINT ["/writefreely/run.sh"]
