---
slug: "github-copilot-login-screen-error-on-intellij-nixos"
title: "GitHub Copilot Login Screen Error on IntelliJ IDEA (NixOS)"
pubDate: 2025-09-28
description: "How to fix the GitHub Copilot 'Getting login screen' issue in IntelliJ IDEA on NixOS."
tags: [nixos,nodejs,copilot,intellij]
---
I just got a Framework 13 laptop with NixOS installed.
I had just installed IntelliJ IDEA Ultimate and got GitHub Copilot on it when I ran into an issue.
I got an error saying that there was an issue getting the login screen.
So, I did some digging and found a solution.

If you are using NixOS and IntelliJ IDEA and you run into this issue, you need Node.js installed on your system.
Once Node.js is installed, restart IntelliJ IDEA and the error should be gone.

Now, you should be able to log in to GitHub Copilot and start using it!
