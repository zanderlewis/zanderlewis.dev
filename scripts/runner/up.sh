#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUNNER_DIR="$ROOT/.runner"
NETWORK="capsule-runner-net"
DIND_NAME="capsule-runner-dind"
RUNNER_NAME="capsule-runner"

if [[ ! -f "$RUNNER_DIR/data/runner-config.yml" ]]; then
  echo "Missing $RUNNER_DIR/data/runner-config.yml — run: make runner-init"
  exit 1
fi

docker network inspect "$NETWORK" >/dev/null 2>&1 || docker network create "$NETWORK"

if ! docker inspect "$DIND_NAME" >/dev/null 2>&1; then
  echo "→ Starting Docker-in-Docker..."
  docker run -d \
    --name "$DIND_NAME" \
    --network "$NETWORK" \
    --privileged \
    --restart unless-stopped \
    docker:dind \
    dockerd -H tcp://0.0.0.0:2375 --tls=false
else
  docker start "$DIND_NAME" >/dev/null 2>&1 || true
  echo "→ Docker-in-Docker already exists"
fi

# Wait for dockerd inside DinD
sleep 3

if ! docker inspect "$RUNNER_NAME" >/dev/null 2>&1; then
  echo "→ Starting Forgejo runner..."
  docker run -d \
    --name "$RUNNER_NAME" \
    --network "$NETWORK" \
    -e DOCKER_HOST=tcp://capsule-runner-dind:2375 \
    -u 1001:1001 \
    -v "$RUNNER_DIR/data:/data" \
    -w /data \
    --restart unless-stopped \
    data.forgejo.org/forgejo/runner:12 \
    forgejo-runner daemon --config /data/runner-config.yml
else
  docker start "$RUNNER_NAME" >/dev/null 2>&1 || true
  echo "→ Forgejo runner already exists"
fi

echo "→ Runner up. Logs: make runner-logs"
