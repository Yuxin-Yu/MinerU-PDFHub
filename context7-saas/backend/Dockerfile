FROM nimlang/nim:2.0.0-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git gcc musl-dev openssl-dev postgresql-dev

# Set working directory
WORKDIR /app

# Copy nimble file first for better caching
COPY context7_saas.nimble .

# Install Nim dependencies
RUN nimble install -y

# Copy source code
COPY backend/ backend/
COPY shared/ shared/

# Build the application
RUN nim c -d:release -d:ssl --opt:speed -o:context7_saas backend/src/context7_saas.nim

# Runtime stage
FROM alpine:3.18

# Install runtime dependencies
RUN apk add --no-cache libssl1.1 postgresql-libs

# Create non-root user
RUN adduser -D -s /bin/sh context7

# Copy binary from builder
COPY --from=builder /app/context7_saas /usr/local/bin/

# Switch to non-root user
USER context7

# Expose port
EXPOSE 8000

# Run the application
CMD ["context7_saas"]