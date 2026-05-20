# syntax=docker/dockerfile:1

ARG NIM_VERSION=2.2.6-ubuntu-slim
FROM nimlang/nim:${NIM_VERSION} AS builder

WORKDIR /app

# 安装nimble和git（如果使用slim镜像）
RUN apt-get update && apt-get install -y curl git && \
    curl -L https://github.com/nim-lang/nimble/releases/download/v0.20.1/nimble-linux_x64.tar.gz -o nimble.tar.gz && \
    tar -xzf nimble.tar.gz && \
    mv nimble /usr/local/bin/ && \
    rm -rf nimble.tar.gz

# Pre-copy the Nimble manifest to leverage Docker layer caching for dependencies
COPY mineru_pdfhub.nimble nim.cfg ./
COPY vendor ./vendor
RUN nimble refresh && nimble install -y --depsOnly

COPY . .
RUN nim c -d:release --opt:size --passC:-flto --passL:-s \
    --nimcache:/tmp/nimcache -o:/app/mineru-pdfhub src/mineru_pdfhub.nim && \
    rm -rf /tmp/nimcache

FROM debian:bookworm-slim AS runtime

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=dev
ARG APP_UID=1000
ARG APP_GID=1000

LABEL org.opencontainers.image.title="MinerU-PDFHub" \
      org.opencontainers.image.description="On-premises MCP server for private/internal documentation." \
      org.opencontainers.image.url="https://github.com/Yuxin-Yu/MinerU-PDFHub" \
      org.opencontainers.image.source="https://github.com/Yuxin-Yu/MinerU-PDFHub" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.licenses="MIT"

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libssl3 libpcre3 git && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd --system --gid "${APP_GID}" mineru-pdfhub && \
    useradd --system --uid "${APP_UID}" --gid mineru-pdfhub --home /app --shell /usr/sbin/nologin mineru-pdfhub && \
    install -d -o mineru-pdfhub -g mineru-pdfhub /config /data /app

ENV MINERU_PDFHUB_CONFIG_DIR=/config \
    MINERU_PDFHUB_DATA_DIR=/data \
    MINERU_PDFHUB_HOST=0.0.0.0 \
    MINERU_PDFHUB_PORT=8080 \
    MINERU_PDFHUB_TRANSPORT=http

WORKDIR /app

COPY --from=builder --chown=mineru-pdfhub:mineru-pdfhub /app/mineru-pdfhub /usr/local/bin/mineru-pdfhub
COPY --chown=mineru-pdfhub:mineru-pdfhub docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

VOLUME ["/config", "/data"]

EXPOSE 8080

USER mineru-pdfhub

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["server"]
