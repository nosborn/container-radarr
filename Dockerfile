FROM debian:13.3-slim

ARG VERSION

ENV COMPlus_EnableDiagnostics=0

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        libicu76 \
        libsqlite3-0 \
        xmlstarlet \
    && rm -rf \
        /var/lib/apt/lists/* \
    && mkdir -p /app \
    && chown 1000:1000 /app

USER 1000:1000

RUN cd /app \
    && curl -fLsS \
        --output /tmp/Radarr.tar.gz \
        --url "https://github.com/Radarr/Radarr/releases/download/v${VERSION:?}/Radarr.master.${VERSION:?}.linux-core-x64.tar.gz" \
    && tar -xzf /tmp/Radarr.tar.gz \
        --exclude=Radarr.Update \
        --strip-components=1 \
    && rm /tmp/Radarr.tar.gz

EXPOSE 7878
VOLUME /data
VOLUME /library

ENTRYPOINT ["/app/Radarr", "-data=/data", "-nobrowser"]
