---
name: scaffolding-project
description: >-
  Use when the repo is empty, has no agent harness, or the user asks to dựng dự án,
  scaffold, bootstrap, or start a project before features are built.
---

# Scaffolding a project

The harness is the memory the next session will not have. Write only what a cold agent cannot discover from the repo in one lookup.

## 1. Inspect

Read what exists: git remote, package or build manifests, test scripts, `AGENTS.md`, `CLAUDE.md`, `GLOSSARY.md`, `docs/adr/`, `docs/agents/`, `STATE.md`, `LOOP.md`.

## 2. Settle the open forks

Ask one fork at a time, and only if inspection left it open. Lead with the recommended answer.

- **Issue tracker.** GitHub remote → GitHub issues. No remote → markdown files in `work/`. Record the choice in `docs/agents/issue-tracker.md`.
- **Maintenance loop.** Default: no. A loop starts at L1 (report only) and only when the user wants the repo watched. Then follow `running-the-loop` for `STATE.md`, `LOOP.md`, `loop-budget.md`, and `loop-run-log.md`.
- **UI product.** If the product has screens, follow `designing-interface` far enough to write `design-system/MASTER.md` before feature work.

Domain docs default to one `GLOSSARY.md` and `docs/adr/` at the repo root. Create `GLOSSARY.md` when the first term is settled. Create `docs/adr/0001-title.md` when the first decision must constrain later work. Skip both until that happens.

## 3. Write the harness

Edit `CLAUDE.md` if it exists. Otherwise edit `AGENTS.md`. If neither exists, create `AGENTS.md`. Leave the other file uncreated.

Keep that file under 200 lines. Put file-scoped rules in a rules file that loads only when those paths are touched.

The file states:

- What the repo is, in one paragraph
- Commands to install, run, test, and lint, copied from the manifests
- How to verify a change in the running app (URL or entry command)
- Where issues live (`docs/agents/issue-tracker.md`)
- Where feature work lives (`work/{slug}/`, see `specifying-a-feature`)
- Denylist: auth, payments, secrets, infra — human merge

Add `work/README.md` with the pipeline: discuss → plan → execute → verify → ship. A new product also gets `PROJECT.md` (one paragraph and non-goals) and `REQUIREMENTS.md` (ids the later verify step can check). Create `docs/agents/issue-tracker.md` with the tracker choice and the five labels `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix` when the tracker is GitHub and those labels are missing.

## Coordination

Read and follow `coordinating-agents` when more than one file is written. One worker owns each of `AGENTS.md` or `CLAUDE.md`, `docs/agents/issue-tracker.md`, `PROJECT.md`, `REQUIREMENTS.md`, and `design-system/MASTER.md`. The verifier checks that the harness commands match the manifests. The skill is done only when those rows are `pass`.

## Done

A cold session can build, test, verify, find the tracker, and find `work/` without asking. Build and test commands in the harness match the manifests.
