---
slug: "github-copilot-login-screen-error-on-intellij-nixos"
title: "GitHub Copilot Login Screen Error on IntelliJ IDEA (NixOS)"
pubDate: 2025-09-28
editedDate: 2025-09-29
description: "How to fix the GitHub Copilot 'Getting login screen' issue in IntelliJ IDEA on NixOS."
tags: [nixos,nodejs,copilot,intellij]
---

If you run IntelliJ IDEA (or any JetBrains IDE) on NixOS and installed the GitHub Copilot plugin, you may encounter a frustrating error where the plugin reports it's "getting login screen" and never completes the OAuth flow.

Why this happens

- JetBrains plugins sometimes rely on external platform tooling (for example, a node binary) rather than bundling everything inside the plugin. The GitHub Copilot plugin uses a helper process that expects a node runtime.
- NixOS has a declarative package management model. If Node.js is not included in your system profile or the environment used to launch IntelliJ, the plugin's helper cannot run and the login flow stalls.

What fixed it for me

1. Add Node.js to your NixOS system configuration so it's available to graphical apps launched from your session. Edit /etc/nixos/configuration.nix (or your common configuration) and add Node.js to environment.systemPackages:

```nix
# /etc/nixos/configuration.nix (excerpt)
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ nodejs ];
}
```

2. Rebuild the system and switch to the new configuration:

```bash
sudo nixos-rebuild switch
```

3. Restart your desktop session (or at least restart IntelliJ IDEA). Launch IntelliJ and try the Copilot sign-in flow again. The plugin should now be able to spawn the helper and open the login flow.

Verifying the fix

- Attempt the Copilot sign-in again. If it still fails, check for errors mentioning "node" or a missing binary. That usually indicates the plugin cannot find node.
- You can also run a quick check in the same environment as your desktop session:

```bash
which node
node --version
```

Troubleshooting tips

- Node version: Copilot's helper is tolerant, but using a recent LTS (16.x/18.x/20.x etc.) is recommended.
- If you installed Node but IntelliJ still shows the error, make sure the IDE process sees your updated PATH. Restarting the whole session (logout/login) or ensuring the session's environment includes node often resolves that.

