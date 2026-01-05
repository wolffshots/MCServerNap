#!/bin/bash
set -e

# This script is called by mcservernap when a player tries to join
# It starts the Minecraft container and waits for it to exit

: "${MC_CONTAINER:=minecraft}"

echo "[MCServerNap] Starting Minecraft container: ${MC_CONTAINER}"

# Start the container (if stopped) or unpause (if paused)
if docker inspect -f '{{.State.Paused}}' "${MC_CONTAINER}" 2>/dev/null | grep -q true; then
    echo "[MCServerNap] Unpausing container..."
    docker unpause "${MC_CONTAINER}"
elif docker inspect -f '{{.State.Running}}' "${MC_CONTAINER}" 2>/dev/null | grep -q false; then
    echo "[MCServerNap] Starting container..."
    docker start "${MC_CONTAINER}"
else
    echo "[MCServerNap] Container already running"
fi

# Wait for the container to stop
# This keeps mcservernap's child process alive while the server is running
echo "[MCServerNap] Waiting for Minecraft container to stop..."
docker wait "${MC_CONTAINER}" 2>/dev/null || true

echo "[MCServerNap] Minecraft container stopped"

