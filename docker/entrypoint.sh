#!/bin/bash
set -e

# Environment variables with defaults
: "${NAP_HOST:=0.0.0.0}"
: "${NAP_PORT:=25565}"
: "${MC_CONTAINER:=minecraft}"
: "${MC_HOST:=minecraft}"
: "${MC_PORT:=25565}"
: "${RCON_HOST:=minecraft}"
: "${RCON_PORT:=25575}"
: "${RCON_PASSWORD:=minecraft}"
: "${IDLE_TIMEOUT:=600}"
: "${POLL_INTERVAL:=60}"
: "${MOTD_TEXT:=Napping... Join to start server}"
: "${MOTD_COLOR:=aqua}"
: "${MOTD_BOLD:=true}"
: "${CONNECTION_MSG_TEXT:=Server is starting up. Please wait and try again...}"
: "${CONNECTION_MSG_COLOR:=light_purple}"
: "${CONNECTION_MSG_BOLD:=true}"

echo "[MCServerNap] Starting sidecar proxy..."
echo "[MCServerNap] Listening on ${NAP_HOST}:${NAP_PORT}"
echo "[MCServerNap] Target container: ${MC_CONTAINER}"
echo "[MCServerNap] Target server: ${MC_HOST}:${MC_PORT}"
echo "[MCServerNap] RCON: ${RCON_HOST}:${RCON_PORT}"
echo "[MCServerNap] Idle timeout: ${IDLE_TIMEOUT}s"

# Create config file
cat > /config/cfg.toml << EOF
rcon_poll_interval = ${POLL_INTERVAL}
rcon_idle_timeout = ${IDLE_TIMEOUT}
motd_text = "${MOTD_TEXT}"
motd_color = "${MOTD_COLOR}"
motd_bold = ${MOTD_BOLD}
connection_msg_text = "${CONNECTION_MSG_TEXT}"
connection_msg_color = "${CONNECTION_MSG_COLOR}"
connection_msg_bold = ${CONNECTION_MSG_BOLD}
config_directory_name = "/config"
EOF

# Export vars for the start script
export MC_CONTAINER MC_HOST MC_PORT RCON_HOST RCON_PORT

# Start mcservernap
# The cmd is our helper script that starts the minecraft container
exec mcservernap listen "${NAP_HOST}" "${NAP_PORT}" \
    --server-port "${MC_PORT}" \
    --rcon-port "${RCON_PORT}" \
    --rcon-pass "${RCON_PASSWORD}" \
    /start-minecraft.sh

