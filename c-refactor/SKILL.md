---
name: c-refactor
description: >-
  Use when the user asks to refactor, deepen a module, or clean structure
  without changing behavior. Use for "refactor", "cấu trúc lại", "dọn module".
  A feature or a bug fix is flow, not this skill.
---

# Refactoring code

Behavior stays the same. Questions follow the Questions section of `c-agents`. If `codebase-design` is installed, use its words for module, interface, depth, and seam. The candidates and the question form in this file stay in charge.

## Before any edit

Run the repo's test command and keep the output. A red suite stops the refactor. Name the area the user named. When they name none, take the files that keep appearing in `git log --oneline` and offer those as the candidates.

Read `GLOSSARY.md` and the ADRs under `docs/adr/` for that area. Use those names. Do not propose a change an ADR already settled unless the user asks to reopen that ADR.

## Candidates

A candidate is one shallow spot: understanding it means jumping across many files, or the interface is as large as the body. Say what would be deleted or inlined, which calls stay, and which tests already cover the behavior.

Write the list to `work/refactor/CANDIDATES.md`. One heading per candidate, then what would be deleted or inlined, which calls stay, and which tests already cover the behavior. More than one candidate goes in one question form. A is the hottest recent area and ends with `(Recommended)`. The last choice is `Người dùng quyết định`. Wait for that answer before editing.

## One pass

After they pick one candidate:

1. Add or keep a test at the public seam that already passes. Do not assert a private helper.
2. Change only that structure. No new behavior, no drive-by format, no new dependency.
3. Re-run the same test command. Quote both outputs. A new failure rolls the edit back. An edit that changes an assertion, or a result the first output already showed, is a new behavior. Roll it back.

The pass is done when the second output matches the first, apart from timing. Three failed attempts on the same candidate stop.
