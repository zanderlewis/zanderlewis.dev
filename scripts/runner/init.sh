#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
RUNNER_DIR="$ROOT/.runner"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "→ Scaffolding $RUNNER_DIR (gitignored)..."

mkdir -p "$RUNNER_DIR/data/.cache"
cp "$SCRIPT_DIR/docker-compose.yml" "$RUNNER_DIR/docker-compose.yml"

if [[ ! -f "$RUNNER_DIR/data/runner-config.yml" ]]; then
  cp "$SCRIPT_DIR/runner-config.yml.example" "$RUNNER_DIR/data/runner-config.yml"
  echo "→ Created .runner/data/runner-config.yml from example"
else
  echo "→ Keeping existing .runner/data/runner-config.yml"
fi

# Fix known invalid values from older examples (file may be owned by uid 1001)
fix_config() {
  sed -i 's/^  shutdown_timeout: 0$/  shutdown_timeout: 0s/' "$RUNNER_DIR/data/runner-config.yml"
}
fix_config 2>/dev/null || sudo sed -i 's/^  shutdown_timeout: 0$/  shutdown_timeout: 0s/' "$RUNNER_DIR/data/runner-config.yml"

# Forgejo runner container runs as uid 1001
if chown -R 1001:1001 "$RUNNER_DIR/data" 2>/dev/null; then
  echo "→ Set data/ ownership to 1001:1001"
elif sudo chown -R 1001:1001 "$RUNNER_DIR/data" 2>/dev/null; then
  echo "→ Set data/ ownership to 1001:1001 (via sudo)"
else
  chmod -R 777 "$RUNNER_DIR/data"
  echo "→ Warning: could not chown to 1001:1001 — run: sudo chown -R 1001:1001 .runner/data"
fi

chmod 775 "$RUNNER_DIR/data/.cache" 2>/dev/null || true

echo ""
echo "Next steps:"
echo "  1. codeberg.org/zanderlewis/website → Settings → Actions → Runners → Create new runner"
echo "  2. Edit .runner/data/runner-config.yml — paste uuid + token under server.connections.codeberg"
echo "  3. make runner-up"
echo "  4. Push to main — workflow uses runs-on: ubuntu-latest"
