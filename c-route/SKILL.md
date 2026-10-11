---
name: c-route
description: >-
  Use when the user asks to dựng dự án, scaffold or start a repo, thêm chức năng,
  add a feature from a doc, ticket, or idea, viết prompt, follow the engineering
  process, or run loop-engineering, triage, or an agent loop. Use when they ask
  to review, refactor, lint, debug, or speed up code and the path is not already chosen.
---

# Routing engineering work

Pick one path, then read that skill and follow it before any other work. One path per request. A second path starts only after the first skill's done condition is met. If the path itself is a question, follow the Questions section of `c-agents`.

| Signal | Skill |
|--------|--------|
| "Tự chạy", "làm chức năng", "làm theo yêu cầu", finish the feature | `c-flow` |
| Empty repo, no harness, "dựng dự án", "start the project" | `c-scaffold` |
| Idea, doc, or ticket, and the user asked to spec only | `c-spec` |
| GO verdict plus a plan, or "implement this spec" | `c-implement` |
| "Viết prompt", agent brief, slash command, automation instruction | `c-prompt` |
| "Thiết kế vòng lặp", design a workflow, what loop should exist | `c-prompt`, then `c-loop` after the prompt exists |
| Recurring loop, triage, CI, PR babysit, "until done" with a budget | `c-loop` |
| Screen, component, layout, color, type, motion, accessibility | `c-design` |
| "Review code", "review PR", "soi diff" | `c-review` |
| "Refactor", "cấu trúc lại", no new behavior | `c-refactor` |
| "Lint", "typecheck", "sửa warning", "soi logic" | `c-lint` |
| "Cho nhanh hơn", "tối ưu perf" | `c-perf` |
| "Debug", "tìm nguyên nhân", "sửa lỗi", `--find`, `--fix` | `c-debug` |

UI inside a feature: run `c-design` during specify (for the design brief) and again during implement (before calling the screen done). The feature skills stay in charge of the gates.

A maintenance loop and a feature are different jobs. Daily triage lists slices. It does not rewrite the repo. A feature the user wants finished goes through `c-flow`. Spec-only and implement-only stay on their own rows.

This skill does not dispatch. The chosen skill reads `c-agents` before it splits work.
