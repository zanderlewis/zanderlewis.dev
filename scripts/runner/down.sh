#!/usr/bin/env bash
set -euo pipefail

docker stop capsule-runner capsule-runner-dind 2>/dev/null || true
echo "→ Runner stopped (containers kept — run make runner-rm to delete)"
