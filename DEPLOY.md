# Deploying zanderlewis.dev

## The problem

Codeberg's **shared** Forgejo Actions runners (`codeberg-small`, etc.) are frequently stuck on *"Waiting for a runner"* — [actions/meta#76](https://codeberg.org/actions/meta/issues/76) was opened today for exactly this. It's not your workflow; the hosted runner pool is overloaded/limited.

## Fastest fix: deploy from your laptop

```bash
export CLOUDFLARE_API_TOKEN="your-token"
export CLOUDFLARE_ACCOUNT_ID="your-account-id"

chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

Or: `make deploy` (same thing).

This builds `public/` and uploads to Cloudflare Pages immediately.

## Reliable CI: self-hosted runner (recommended)

Run Actions jobs on your Kubuntu machine instead of waiting for Codeberg's shared pool.

### 1. Create a runner token

[codeberg.org/zanderlewis/website](https://codeberg.org/zanderlewis/website) → **Settings → Actions → Runners → Create new runner**

Copy the registration token.

### 2. Install and register `forgejo-runner`

```bash
# Download latest forgejo-runner for linux amd64 from:
# https://codeberg.org/forgejo/runner/releases

forgejo-runner register \
  --instance https://codeberg.org \
  --token YOUR_REGISTRATION_TOKEN \
  --name kubuntu-laptop \
  --labels self-hosted:host

forgejo-runner daemon
```

Keep `forgejo-runner daemon` running (or install as a systemd user service).

### 3. Repository secrets

**Settings → Actions → Secrets:**

| Secret | Value |
|--------|--------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token (Pages Edit) |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID |

### 4. Push to main

The workflow uses `runs-on: self-hosted` and will run on your machine.

## Cloudflare custom domain

**Workers & Pages → website → Custom domains** → add `zanderlewis.dev`

Point DNS to Cloudflare and remove old Gigalixir records.

## Prerequisites on your machine

- `crystal`, `shards` (already installed)
- `node` / `npx` (for wrangler)
- Cloudflare secrets in the repo (for CI) or env (for local deploy)
