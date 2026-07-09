# Cloudflare Pages — zanderlewis.dev

This site is a static build (`public/`) deployed to **Cloudflare Pages** from Codeberg CI.

## One-time setup

### 1. Cloudflare API token

In the [Cloudflare dashboard](https://dash.cloudflare.com/profile/api-tokens), create a token with:

- **Account** → Cloudflare Pages → Edit
- **Account** → Account Settings → Read (for account ID lookup)

Copy your **Account ID** from the Pages overview sidebar.

### 2. Codeberg repository secrets

In [codeberg.org/zanderlewis/website](https://codeberg.org/zanderlewis/website) → **Settings → Actions → Secrets**, add:

| Secret | Value |
|--------|--------|
| `CLOUDFLARE_API_TOKEN` | API token from step 1 |
| `CLOUDFLARE_ACCOUNT_ID` | Your Cloudflare account ID |

### 3. Cloudflare Pages project

On the first successful CI run, Wrangler creates a Pages project named `website` (or attaches to an existing one with that name).

In **Workers & Pages → website → Custom domains**, add:

- `zanderlewis.dev`
- `www.zanderlewis.dev` (optional)

### 4. Retire Gigalixir

Remove the old Elixir/Phoenix app from Gigalixir and delete any DNS records pointing there once Cloudflare Pages is live.

## Manual deploy

```bash
make build
npx wrangler pages deploy public --project-name=website
```

Requires `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` in your environment.

## Build locally

```bash
shards install
shards build --release
./bin/capsule build   # writes to public/
make serve            # preview at :3000
```
