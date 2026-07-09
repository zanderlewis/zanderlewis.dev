#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "→ Installing shards..."
shards install

echo "→ Building Capsule binary..."
shards build --release

echo "→ Generating site..."
./bin/capsule build

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]]; then
  echo ""
  echo "Set CLOUDFLARE_API_TOKEN and CLOUDFLARE_ACCOUNT_ID, then re-run:"
  echo "  CLOUDFLARE_API_TOKEN=... CLOUDFLARE_ACCOUNT_ID=... ./scripts/deploy.sh"
  exit 1
fi

echo "→ Ensuring Cloudflare Pages project exists..."
npx wrangler@4 pages project create website --production-branch=main || true

echo "→ Deploying to Cloudflare Pages..."
npx wrangler@4 pages deploy public --project-name=website --branch=main

echo "Done. Check Cloudflare Pages for zanderlewis.dev."
