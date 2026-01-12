#!/usr/bin/env bash
# Build Clawdbot image for GHCR deployment
#
# Usage:
#   ./scripts/docker/build-ghcr.sh [TAG]
#
# Examples:
#   ./scripts/docker/build-ghcr.sh          # Uses git tag or 'dev'
#   ./scripts/docker/build-ghcr.sh v1.2.3   # Specific tag
#
# Environment:
#   CLAWDBOT_GHCR_IMAGE - Override image name (default: ghcr.io/andyeskridge/clawdbot)

set -euo pipefail

cd "$(dirname "$0")/../.."

IMAGE_NAME="${CLAWDBOT_GHCR_IMAGE:-ghcr.io/andyeskridge/clawdbot}"
TAG="${1:-$(git describe --tags --always 2>/dev/null || echo dev)}"

echo "Building $IMAGE_NAME:$TAG ..."

docker build \
  --platform linux/amd64 \
  --tag "$IMAGE_NAME:$TAG" \
  --tag "$IMAGE_NAME:latest" \
  --label "org.opencontainers.image.revision=$(git rev-parse HEAD)" \
  --label "org.opencontainers.image.version=$TAG" \
  -f Dockerfile.ghcr \
  .

echo ""
echo "Built successfully:"
echo "  $IMAGE_NAME:$TAG"
echo "  $IMAGE_NAME:latest"
echo ""
echo "To push: ./scripts/docker/push-ghcr.sh $TAG"
