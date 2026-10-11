---
name: checking-lint
description: >-
  Use when the user asks to lint, typecheck, fix warnings, or check logic
  the tools can show. Use for "lint", "sửa warning", "typecheck", "soi logic".
  Do not add a formatter or a git hook unless they asked for that hook.
---

# Checking lint

Use the commands this repo already has. Questions follow the Questions section of `coordinating-agents`.

## Commands

Look up the lint and typecheck scripts in the repo (`package.json`, `Makefile`, `pyproject.toml`, `Cargo.toml`, or the file the project documents). Run those. A repo with no such command stops and asks, in one form, whether to add the ecosystem's usual checker. Do not install Prettier, Husky, or a hook as a side effect of a lint request.

## Fix the tool output

Fix only the diagnostics that command printed. Re-run the same command. Quote the last output. Done when that output is clean for the command's own failure rule. A warning the command does not fail on is listed and left, unless the user asked to clear warnings too.

Do not reformat a file the tool did not name. Do not change behavior to silence a diagnostic. If the honest fix changes behavior, stop and put that choice in the question form. After a fix, re-run the test that covers each file whose logic changed and quote it. A file with no such test is named, not treated as clean.

## Logic on the same scope

After the tool run, read the files the command named, or the files the user named. A logic note needs a quoted line and the wrong outcome. Separate heading from the tool output. A note without an outcome is not a fix.

A logic fix that changes what users see is `processing-the-flow`, not a lint edit.
