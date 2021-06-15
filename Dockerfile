FROM debian:stable-slim

RUN mkdir -p /writefreely/temp
RUN apt-get update && apt-get install curl -y && rm -rf /var/lib/apt/lists/*
RUN cd /writefreely/temp && \
  curl -LJO https://github.com/writefreely/writefreely/releases/download/v0.13.0/writefreely_0.13.0_linux_amd64.tar.gz && \
  tar -xf writefreely_0.13.0_linux_amd64.tar.gz && \
  mv writefreely/* .. && \
  cd /writefreely && \
  rm -rf temp

WORKDIR /writefreely

COPY bin/run.sh .

VOLUME /data
VOLUME /config
EXPOSE 8080

ENTRYPOINT ["./run.sh"]
