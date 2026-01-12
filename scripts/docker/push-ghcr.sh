#!/usr/bin/env bash
# Push Clawdbot image to GHCR
#
# Usage:
#   ./scripts/docker/push-ghcr.sh [TAG]
#
# Examples:
#   ./scripts/docker/push-ghcr.sh          # Uses git tag or 'dev'
#   ./scripts/docker/push-ghcr.sh v1.2.3   # Specific tag
#
# Prerequisites:
#   Login to GHCR first:
#   echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
#
# Environment:
#   CLAWDBOT_GHCR_IMAGE - Override image name (default: ghcr.io/andyeskridge/clawdbot)

set -euo pipefail

cd "$(dirname "$0")/../.."

IMAGE_NAME="${CLAWDBOT_GHCR_IMAGE:-ghcr.io/andyeskridge/clawdbot}"
TAG="${1:-$(git describe --tags --always 2>/dev/null || echo dev)}"

echo "Pushing $IMAGE_NAME:$TAG ..."
docker push "$IMAGE_NAME:$TAG"

echo "Pushing $IMAGE_NAME:latest ..."
docker push "$IMAGE_NAME:latest"

echo ""
echo "Pushed successfully:"
echo "  $IMAGE_NAME:$TAG"
echo "  $IMAGE_NAME:latest"
