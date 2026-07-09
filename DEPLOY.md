# Deploying zanderlewis.dev

## CI: Docker Forgejo runner (recommended)

Codeberg shared runners are stuck/unreliable. Run your own runner in Docker per the [Forgejo docs](https://forgejo.codeberg.page/docs/latest/admin/actions/installation/docker/).

All runner state lives in **`.runner/`** (gitignored — tokens never committed).

### 1. Scaffold the runner directory

```bash
make runner-init
```

Creates `.runner/` with `docker-compose.yml` and `data/runner-config.yml`.

### 2. Get Codeberg credentials

[website → Settings → Actions → Runners → Create new runner](https://codeberg.org/zanderlewis/website/settings/actions/runners)

Copy the **UUID** and **token** (shown once).

### 3. Edit config

Open `.runner/data/runner-config.yml` and replace:

```yaml
server:
  connections:
    codeberg:
      uuid: YOUR_UUID
      token: YOUR_TOKEN
```

### 4. Start the runner

```bash
sudo chown -R 1001:1001 .runner/data   # if needed
make runner-up
make runner-logs
```

Uses plain `docker run` (no Compose plugin required). Optional: install `docker-compose-v2` if you prefer `docker compose`.
```

Runner should show **Idle** in Codeberg. The workflow uses `runs-on: crystal` which maps to the `crystallang/crystal:1.16.3-alpine` job container.

### 5. Repository secrets

**Settings → Actions → Secrets:**

| Secret | Value |
|--------|--------|
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token (Pages Edit) |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID |

Push to `main` to deploy.

### Stop the runner

```bash
make runner-down
```

---

## Manual deploy (no CI)

```bash
export CLOUDFLARE_API_TOKEN="..."
export CLOUDFLARE_ACCOUNT_ID="..."
make deploy
```

---

## Cloudflare custom domain

**Workers & Pages → website → Custom domains** → add `zanderlewis.dev`

Remove old Gigalixir DNS records when live.
