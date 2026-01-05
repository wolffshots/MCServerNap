# Build stage
FROM rust:1.83-slim-bookworm AS builder

WORKDIR /build

# Install build dependencies
RUN apt-get update && apt-get install -y \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Copy source and build
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies and Docker CLI
RUN apt-get update && apt-get install -y \
    ca-certificates \
    docker.io \
    && rm -rf /var/lib/apt/lists/*

# Copy binary
COPY --from=builder /build/target/release/mcservernap /usr/local/bin/mcservernap
RUN chmod +x /usr/local/bin/mcservernap

# Copy entrypoint and helper scripts
COPY docker/entrypoint.sh /entrypoint.sh
COPY docker/start-minecraft.sh /start-minecraft.sh
RUN chmod +x /entrypoint.sh /start-minecraft.sh

# Create config directory
RUN mkdir -p /config

WORKDIR /config

EXPOSE 25565

ENTRYPOINT ["/entrypoint.sh"]

