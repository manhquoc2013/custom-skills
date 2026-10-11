---
name: routing-engineering-work
description: >-
  Use when the user asks to dựng dự án, scaffold or start a repo, thêm chức năng,
  add a feature from a doc, ticket, or idea, viết prompt, follow the engineering
  process, or run loop-engineering, triage, or an agent loop. Use when the path
  (scaffold, specify, implement, prompt, loop, or UI) is not already chosen.
---

# Routing engineering work

Pick one path, then read that skill and follow it before any other work. One path per request. A second path starts only after the first skill's done condition is met.

| Signal | Skill |
|--------|--------|
| "Tự chạy", "làm chức năng", "làm theo yêu cầu", finish the feature | `processing-the-flow` |
| Empty repo, no harness, "dựng dự án", "start the project" | `scaffolding-project` |
| Idea, doc, or ticket, and the user asked to spec only | `specifying-a-feature` |
| GO verdict plus a plan, or "implement this spec" | `implementing-from-spec` |
| "Viết prompt", agent brief, slash command, automation instruction | `prompting-the-loop` |
| Recurring loop, triage, CI, PR babysit, "until done" with a budget | `running-the-loop` |
| Screen, component, layout, color, type, motion, accessibility | `designing-interface` |

UI inside a feature: run `designing-interface` during specify (for the design brief) and again during implement (before calling the screen done). The feature skills stay in charge of the gates.

A maintenance loop and a feature are different jobs. Daily triage lists slices. It does not rewrite the repo. A feature the user wants finished goes through `processing-the-flow`. Spec-only and implement-only stay on their own rows.
