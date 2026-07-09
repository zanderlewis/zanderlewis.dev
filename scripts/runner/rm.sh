#!/usr/bin/env bash
set -euo pipefail

docker rm -f capsule-runner capsule-runner-dind 2>/dev/null || true
docker network rm capsule-runner-net 2>/dev/null || true
echo "→ Runner containers and network removed"
