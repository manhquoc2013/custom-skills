---
name: c-spec
description: >-
  Use when the user wants a new feature, change, or refactor from an idea, a
  document, a ticket, or the current conversation, and implementation has not
  started. Use for thêm chức năng, spec, plan, research, GO/NO-GO, or a foggy
  idea that is too big for one session.
---

# Specifying a feature

No implementation in this skill. The artifact is a verdict and, only after GO, a plan. Code starts in `c-implement`.

When this skill is the top-level call, run the Grill section of `c-flow` before research. Do not plan while that frontier is still open. Any other question follows the Questions section of `c-agents`.

When `c-flow` is the caller, `CONTEXT.md` is already locked. Do not ask again. Do not rewrite Requirements, Failure, or Out of scope. Append a Kept row only when research has run the command and quoted the output. Read and follow `writing-plans`, then write a plan that gives every `REQ-` id exactly one task. Save it to `work/{slug}/plan/PLAN.md`. If a `REQ-` line has no expected result, use the fog path instead of planning.

## Pick the shape

Pick one row, then read that file before you write anything. The three shapes are exclusive: only the chosen shape's file is needed this session.

| Shape | When | Read |
|-------|------|------|
| Fog | The destination is real and the route is not visible inside one session. Chart a map. Resolve at most one decision this session, then stop. | `shapes/fog.md` |
| Settled | The user already answered the decisions. Do not ask those again. Still ask any assumption they did not settle. | `shapes/settled.md` |
| Open feature | An idea or a source doc, one feature, questions still open. Run research, then plan only on GO. | `shapes/open.md` |

## Before you publish

Reject the spec or plan before the user sees it when it contains a placeholder, a contradiction, a `REQ-` line with no expected result, a task with no failing test, a task with no produces line, or a later task that consumes a name no earlier task produces. Fix those in place. A task in a wave does not depend on another task in that same wave.

## Coordination

Read and follow `c-agents` when research is split. One worker owns the code notes, one owns the product notes, and one owns the feasibility notes. The planner starts after they return. The verifier checks that every `REQ-` id has one task, one kept command or `none`, and one verify command. The skill is done only when that verifier row is `pass`.

## Done

`RESEARCH.md` contains a verdict line, or a settled `SPEC.md` exists with seams the user confirmed. `PLAN.md` exists only after GO or a settled spec, and only after `CONTEXT.md` when the path was an open feature. The next session can execute T1 without a new product decision.
