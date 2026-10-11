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

After the pack is linked, the script recommends bundles from `recommended-skills.tsv` that are not already on the machine, and asks whether to install those into the IDEs just chosen. Enter means yes. `n` skips them. A skill that already has `SKILL.md` in a known skill directory or the Cursor plugin cache is not cloned and not linked again. Do not install a missing bundle unless the user accepts. `--with-recommended` accepts without a prompt. `--no-recommended` skips the question.

On Windows PowerShell, from this repo:

```powershell
./scripts/install.ps1 --list
./scripts/install.ps1
./scripts/install.ps1 --update
```

A new version is a new `VERSION` file. Links point at this repo, so skill text updates when the repo updates. `--update` refreshes the links and rewrites `.engineering-skills-version` in each chosen IDE skill folder.

After linking, tell the user to open a new chat and type `/processing-the-flow`.
