---
name: c-route
description: >-
  Use when the user asks to dựng dự án, thêm chức năng, viết prompt, or run an
  agent loop; or when they ask to review, refactor, lint, debug, or speed up
  code and the path is not already chosen.
---

# Routing engineering work

Pick one path, then read that skill and follow it before any other work. One path per request. A second path starts only after the first skill's done condition is met. If the path itself is a question, follow the Questions section of `c-agents`.

Every skill in this pack carries its own trigger in its `description`, which is already loaded. Match the request against those directly. Only the two rows below need a rule the descriptions cannot carry, so they are the only rows kept here.

| Signal | Path, and why it is not one skill |
|--------|-----------------------------------|
| Idea, doc, or ticket, and the user asked to spec only | `c-spec`, and stop there. It does not start code. |
| "Thiết kế vòng lặp", design a workflow, what loop should exist | `c-prompt` first, then `c-loop` once the prompt exists. The design is a prompt before it is a cadence. |

UI inside a feature: run `c-design` during specify (for the design brief) and again during implement (before calling the screen done). The feature skills stay in charge of the gates.

A maintenance loop and a feature are different jobs. Daily triage lists slices. It does not rewrite the repo. A feature the user wants finished goes through `c-flow`. Spec-only is `c-spec`; implement-only is `c-implement`. Do not collapse either into the other.

This skill does not dispatch. The chosen skill reads `c-agents` before it splits work.
