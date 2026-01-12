#!/usr/bin/env bash
# Deploy Clawdbot to a remote host via SSH
#
# Usage:
#   ./scripts/docker/deploy-host.sh user@host
#
# Examples:
#   ./scripts/docker/deploy-host.sh root@192.168.1.100
#   ./scripts/docker/deploy-host.sh user@my-vps.example.com
#
# Prerequisites:
#   - SSH access to target host
#   - Docker + Docker Compose installed on target host
#
# Environment:
#   CLAWDBOT_GATEWAY_TOKEN - Gateway token (auto-generated if not set)

set -euo pipefail

HOST="${1:?Usage: deploy-host.sh user@host}"
TOKEN="${CLAWDBOT_GATEWAY_TOKEN:-$(openssl rand -hex 32)}"

SCRIPT_DIR="$(dirname "$0")"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Deploying Clawdbot to $HOST ..."
echo ""

# Create directories on remote host
echo "Creating directories on remote host..."
ssh "$HOST" "mkdir -p ~/clawdbot/data/config ~/clawdbot/data/workspace"

# Copy compose file
echo "Copying docker-compose.ghcr.yml..."
scp "$REPO_ROOT/docker-compose.ghcr.yml" "$HOST:~/clawdbot/docker-compose.yml"

# Create .env and start the service
echo "Starting Clawdbot gateway..."
ssh "$HOST" "cd ~/clawdbot && \
  echo 'CLAWDBOT_GATEWAY_TOKEN=$TOKEN' > .env && \
  docker compose pull && \
  docker compose up -d"

echo ""
echo "Deployment complete!"
echo ""
echo "Gateway token: $TOKEN"
echo ""
echo "To access the gateway from your local machine:"
echo "  ssh -N -L 18789:127.0.0.1:18789 $HOST"
echo ""
echo "Then open: http://localhost:18789"
echo "Or check health: curl http://localhost:18789/healthz"
