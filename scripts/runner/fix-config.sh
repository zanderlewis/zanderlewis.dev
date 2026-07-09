#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CONFIG="$ROOT/.runner/data/runner-config.yml"

if [[ ! -f "$CONFIG" ]]; then
  echo "Missing $CONFIG — run: make runner-init"
  exit 1
fi

fix() {
  sed -i 's/^  shutdown_timeout: 0$/  shutdown_timeout: 0s/' "$CONFIG"
}
fix 2>/dev/null || sudo sed -i 's/^  shutdown_timeout: 0$/  shutdown_timeout: 0s/' "$CONFIG"

echo "→ Fixed runner-config.yml"
grep shutdown_timeout "$CONFIG"
