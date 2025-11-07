# syntax=docker/dockerfile:1

ARG NIM_VERSION=2.2.4
FROM nimlang/nim:${NIM_VERSION} AS builder

WORKDIR /app

# Pre-copy the Nimble manifest to leverage Docker layer caching for dependencies
COPY opencontext7.nimble nim.cfg ./
COPY vendor ./vendor
RUN nimble refresh && nimble install -y --depsOnly

COPY . .
RUN nim c -d:release --opt:size --passC:-flto --passL:-s \
    --nimcache:/tmp/nimcache -o:/app/opencontext7 src/opencontext7.nim && \
    rm -rf /tmp/nimcache

FROM debian:bookworm-slim AS runtime

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=dev
ARG APP_UID=1000
ARG APP_GID=1000

LABEL org.opencontainers.image.title="OpenContext7" \
      org.opencontainers.image.description="On-premises MCP server for private/internal documentation." \
      org.opencontainers.image.url="https://github.com/jasagiri/mcp-context7local" \
      org.opencontainers.image.source="https://github.com/jasagiri/mcp-context7local" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libssl3 libpcre3 git && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid "${APP_GID}" opencontext7 && \
    useradd --system --uid "${APP_UID}" --gid opencontext7 --home /app --shell /usr/sbin/nologin opencontext7 && \
    install -d -o opencontext7 -g opencontext7 /config /data /app

ENV OPENCONTEXT7_CONFIG_DIR=/config \
    OPENCONTEXT7_DATA_DIR=/data \
    OPENCONTEXT7_HOST=0.0.0.0 \
    OPENCONTEXT7_PORT=8080 \
    OPENCONTEXT7_TRANSPORT=http

WORKDIR /app

COPY --from=builder --chown=opencontext7:opencontext7 /app/opencontext7 /usr/local/bin/opencontext7
COPY --chown=opencontext7:opencontext7 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/config", "/data"]

EXPOSE 8080

USER opencontext7

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["server"]
