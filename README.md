# Zander Lewis

Personal site built with [Capsule](https://codeberg.org/zanderlewis/capsule) — a Crystal SSG with CML markup. Deployed to Cloudflare Pages from Codeberg.

**Live:** [zanderlewis.dev](https://zanderlewis.dev)

## Quick start

```bash
shards install
make build
make serve
```

See [DEPLOY.md](DEPLOY.md) for Cloudflare Pages setup.

## Layout

```
content/       # .cml pages
templates/     # HTML shell
assets/        # CSS
public/        # build output (gitignored)
capsule.yml    # site config
```

## CLI

```bash
shards run -- build
shards run -- serve
```
