---
name: installing-skills
description: >-
  Use when the user wants to install or update this skill pack, choose which
  IDE receives it, or detect Cursor, Claude, Antigravity, Codex on the machine.
  Use for cài skill, update skill, or phiên bản mới.
---

# Installing skills

Run the installer. It copies each skill folder into the IDE skill directory as a real directory with a real `SKILL.md`, the same shape as other installed skills. Do not symlink the skill directory. When you ask which IDE or whether to install the recommended bundles, follow the Questions section of `coordinating-agents`.

When this repo is not already on the machine, one command downloads a snapshot into a temp directory, installs, then deletes that directory:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/manhquoc2013/custom-skills/main/scripts/bootstrap.sh)"
```

On Windows PowerShell:

```powershell
& ([scriptblock]::Create((Invoke-RestMethod https://raw.githubusercontent.com/manhquoc2013/custom-skills/main/scripts/bootstrap.ps1)))
```

On macOS or Git Bash, from this repo:

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

`--update` recopies skills only for IDEs whose installed version differs from the `VERSION` file in this repo.

After the pack is copied, the script recommends bundles from `recommended-skills.tsv` that are not already on the machine, and asks whether to copy those into the IDEs just chosen. Enter means yes. `n` skips them. A skill that already has `SKILL.md` in a known skill directory or the Cursor plugin cache is left in place. Do not install a missing bundle unless the user accepts. `--with-recommended` accepts without a prompt. `--no-recommended` skips the question.

On Windows PowerShell, from this repo:

```powershell
./scripts/install.ps1 --list
./scripts/install.ps1
./scripts/install.ps1 --update
```

A new version is a new `VERSION` file plus `--update`, which recopies the skill folders. After that, tell the user to open a new chat and type `/processing-the-flow`.
