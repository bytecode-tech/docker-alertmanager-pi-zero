FROM alpine:3.12

ARG ARCHITECTURE=armv6
ARG VERSION=0.21.0

RUN apk --no-cache add --virtual build-dependencies wget ca-certificates && \
    mkdir -p /tmp/install && \
    wget -O /tmp/install/alertmanager.tar.gz https://github.com/prometheus/alertmanager/releases/download/v$VERSION/alertmanager-$VERSION.linux-$ARCHITECTURE.tar.gz && \
    apk del build-dependencies && \
    cd /tmp/install && \
    tar --strip-components=1 -xzf alertmanager.tar.gz && \
    mkdir -p /etc/alertmanager /data/alertmanager && \
    mv alertmanager amtool /bin/ && \
    mv alertmanager.yml /etc/alertmanager/alertmanager.yml && \
    rm -rf /tmp/install && \
    chown -R nobody:nogroup /etc/alertmanager /data/alertmanager

USER       nobody
EXPOSE     9093
VOLUME     [ "/data" ]
WORKDIR    /alertmanager
ENTRYPOINT [ "/bin/alertmanager" ]
CMD        [ "--config.file=/etc/alertmanager/alertmanager.yml", \
             "--storage.path=/alertmanager" ]