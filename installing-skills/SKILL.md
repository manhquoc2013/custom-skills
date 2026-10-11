---
name: installing-skills
description: >-
  Use when the user wants to install or update this skill pack, choose which
  IDE receives it, or detect Cursor, Claude, Antigravity, Codex on the machine.
  Use for cài skill, update skill, or phiên bản mới.
---

# Installing skills

Run the installer from this repo. Do not copy skill folders by hand.

On macOS or Git Bash:

```bash
./scripts/install.sh --list
./scripts/install.sh
```

`--list` prints the IDEs it found and the installed version. With no flag, it asks which numbers to install. Enter installs every IDE it found.

```bash
./scripts/install.sh --all
./scripts/install.sh --update
./scripts/install.sh --only cursor claude
```

`--update` relinks only IDEs whose installed version differs from the `VERSION` file in this repo.

On Windows PowerShell, from this repo:

```powershell
./scripts/install.ps1 --list
./scripts/install.ps1
./scripts/install.ps1 --update
```

A new version is a new `VERSION` file. Links point at this repo, so skill text updates when the repo updates. `--update` refreshes the links and rewrites `.engineering-skills-version` in each chosen IDE skill folder.

After linking, tell the user to open a new chat and type `/processing-the-flow`.
