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

- **Fog.** The destination is real and the route is not visible inside one session. Chart a map. Resolve at most one decision this session, then stop.
- **Settled.** The user already answered the decisions. Do not ask those again. Still ask any assumption they did not settle.
- **Open feature.** An idea or a source doc, one feature, questions still open. Run research, then plan only on GO.

## Fog — the map

Name the destination in one or two lines (a spec, a decision, or a change). Write `work/maps/{slug}.md` from `templates/map.md`.

Each open decision is its own note under `work/maps/{slug}/` with `## Question` and a type: research, prototype, grilling, or task. A question that cannot be phrased sharply stays under Not yet specified. Work past the destination goes under Out of scope.

Grilling and prototype decisions need the user in the loop. Research can run without them. Record the answer on the decision, gist it in Decisions so far, and graduate any fog that is now a sharp question.

A prototype decision answers one question in throwaway code. Delete it unless the user keeps it. It is not the feature.

If charting shows the whole route is already clear, drop the map and use the open-feature path.

Several independent subsystems are not one spec. Name the pieces, ask which is first, and specify only that piece.

## Settled — the spec

Explore the code. Read `GLOSSARY.md` and the ADRs under `docs/adr/` that touch this area. Use those words. A new term goes into `GLOSSARY.md`. A decision later work must obey goes into `docs/adr/` as the next number. Prefer an existing public boundary for tests. Each seam line says what it catches and what it misses. Implementation decisions name modules and contracts, not file paths. Confirm the seams with the user before publishing.

Write `work/{slug}/plan/SPEC.md` from `templates/spec.md`.

One story is one outcome, not a chain of steps. Implementation decisions name modules, interfaces, schema, and API contracts. Leave out file paths and code. Testing decisions name the public behavior and the prior tests to copy. Publish to the issue tracker from `docs/agents/issue-tracker.md` when that file exists, labelled `ready-for-agent`.

## Open feature — research, then plan

Create `work/{slug}/REQUEST.md` from `templates/request.md`.

Read `REQUEST.md` and any project principles. If a requirement is ambiguous, stop and ask. Then write `work/{slug}/research/RESEARCH.md` from `templates/research.md`.

Every Already or Touches claim cites a file and a symbol. Do not change frozen Requirements, Failure, or Out of scope. When a Touches behavior is missing from Kept, append that Kept row only after its command has been run and the output quoted. No such command: set `Stop` to `needs-human`. Do not add a `REQ-`.

Stop on NO-GO. State the reason and the smallest change that would reopen it.

On GO or an accepted CONDITIONAL, lock decisions before the plan. Write `work/{slug}/CONTEXT.md` with every heading from the CONTEXT template in `c-flow/templates/context.md`. A screen also follows `c-design` and writes `plan/ux.md`.

Then write:

- `work/{slug}/plan/pm.md` — stories and acceptance checks, each with a requirement id
- `work/{slug}/plan/eng.md` — boundaries, data, contracts, seams
- `work/{slug}/plan/PLAN.md` — tasks in waves

Each task is one `REQ-` id. Write `work/{slug}/plan/PLAN.md` from `templates/plan.md`.

A task is one behavior with its own test cycle. Fold setup into the task that needs it. A setup-only line is not a task. Tasks in one wave must not edit the same file. A task without a verify command is not a task. A task whose files already exist names the command that locks each public behavior this diff can change. `none` is allowed only when that seam has no public behavior yet. The plan does not add work `CONTEXT.md` marked out of scope.

Before publishing, reject the spec or plan when it contains a placeholder, a contradiction, a `REQ-` line with no expected result, a task with no failing test, a task with no produces line, or a later task that consumes a name no earlier task produces. Fix those in place. A task in a wave does not depend on another task in that same wave.

## Coordination

Read and follow `c-agents` when research is split. One worker owns the code notes, one owns the product notes, and one owns the feasibility notes. The planner starts after they return. The verifier checks that every `REQ-` id has one task, one kept command or `none`, and one verify command. The skill is done only when that verifier row is `pass`.

## Done

`RESEARCH.md` contains a verdict line, or a settled `SPEC.md` exists with seams the user confirmed. `PLAN.md` exists only after GO or a settled spec, and only after `CONTEXT.md` when the path was an open feature. The next session can execute T1 without a new product decision.
