# AGENTS.md

## What this repo is

A skill pack for coding agents — 18 skills for Cursor, Claude Code, Codex, and Antigravity. Each skill is a folder at the repo root holding a `SKILL.md` plus the files it reads on demand. The pack is installed by **copying** each skill folder into an IDE's skill directory; it is never symlinked.

`ref/` holds six vendored reference repositories. They are read-only source material for how other packs solve a problem — not part of the product, and not installed.

## Layout

```text
c-*/SKILL.md              the body of one skill, loaded when that skill fires
c-*/templates/            one file per artifact a skill writes; read only when about to write it
c-*/references/           harness- or moment-specific files; read only when a row points there
c-flow/phases/            one file per pipeline phase; read only when FLOW.md's Phase names it
c-spec/shapes/            one file per request shape; exactly one is read
scripts/                  install.sh, install.ps1, bootstrap.{sh,ps1}, link-skills.sh, agents.tsv
tests/                    test_install_crlf.sh — the only test in the repo
VERSION                   the pack version; `--update` compares it against each IDE's installed copy
recommended-skills.tsv    bundles offered after the pack is installed
```

## Commands

There is no build system: no `package.json`, no Makefile, no linter, no typechecker. Nothing to compile.

```bash
./scripts/install.sh --list          # IDEs found + installed version
./scripts/install.sh --all           # install into every IDE found
./scripts/install.sh --update        # recopy only where the version differs
./scripts/install.sh --only cursor claude

bash tests/test_install_crlf.sh      # the repo's only test
```

`bash` is not always on `PATH`. On this Windows host, `bash <script>` fails with `execvpe(/bin/bash) failed` because the default WSL distribution is `docker-desktop`, which has no bash. Run the shell scripts through the Ubuntu distribution instead:

```bash
wsl.exe -d Ubuntu -e bash tests/test_install_crlf.sh
```

Windows drive paths reach WSL as `/mnt/c/...`. The WSL home is reachable from Windows as `\\wsl$\Ubuntu\home\<user>`.

`ui-ux-pro-max` is a separate optional skill, not installed by this repo's scripts.

## Line endings — do not get this wrong

`.gitattributes` pins:

- `*.sh` → `eol=lf`. A CRLF shell script breaks the installer; `tests/test_install_crlf.sh` exists precisely because that happened once.
- `*.ps1` → `eol=crlf`.
- everything else → `text=auto`, which means **CRLF in the working tree** on Windows, LF in the object store.

A `.md` file written on Windows should end CRLF in the working tree. Git warns `LF will be replaced by CRLF` when it does not. The `edit` tool's `normalizeLineEndings: "crlf"` fixes a file after it is written.

## Editing the skills

Read `c-skill/SKILL.md` before changing any skill body, and `c-agents/SKILL.md` before changing how skills split work. Five rules, each of which has already been violated once:

1. **Section names are a contract.** `c-process`, `c-spec`, and `c-implement` point at named sections of `c-flow` — "the Grill section", "the plan check". Renaming or moving a section without updating every pointer leaves a dangling reference. Grep for the name before you move it.
2. **Keep the frontmatter.** Dropping a `SKILL.md` frontmatter block silently unregisters that skill; it disappears from the agent's skill list. Easy to lose when rewriting a whole file — read `git diff` for a line that starts with `-name:`.
3. **`VERSION` drives `--update`.** An installed copy is recopied only when its version differs from this file. Bump it for anything users should receive.
4. **One change ships to four harnesses.** Prefer wording that is neutral between them over a mechanism only one supports — for example Claude Code's `paths:` lazy-load frontmatter.
5. **One story, one home.** When the same fact lives in more than one file, one file is the source and the others point at it or summarise it. Change the source first, then propagate. The install story's home is `c-install/SKILL.md`, which carries every flag; `README.md` and the Commands section above are summaries of it. The harness list's home is `c-agents/SKILL.md`.

## Committing

`.ai-kit/memory.db` is tracked engine state that mutates on its own; `.ai-kit/memory.db-shm` and `.ai-kit/memory.db-wal` are untracked. Check `git status` before `git add` so engine state does not ride along with a content change.

Auth, payments, secrets, and infrastructure work waits for a human.
