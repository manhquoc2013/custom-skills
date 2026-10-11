---
name: specifying-a-feature
description: >-
  Use when the user wants a new feature, change, or refactor from an idea, a
  document, a ticket, or the current conversation, and implementation has not
  started. Use for thêm chức năng, spec, plan, research, GO/NO-GO, or a foggy
  idea that is too big for one session.
---

# Specifying a feature

No implementation in this skill. The artifact is a verdict and, only after GO, a plan. Code starts in `implementing-from-spec`.

When `processing-the-flow` is the caller, `CONTEXT.md` is already locked. Do not ask again and do not rewrite its slots. Read and follow `writing-plans`, then write a plan that gives every `REQ-` id exactly one task. Save it to `work/{slug}/plan/PLAN.md`. The fog path does not apply.

## Pick the shape

- **Fog.** The destination is real and the route is not visible inside one session. Chart a map. Resolve at most one decision this session, then stop.
- **Settled.** The conversation already chose the behavior. Synthesize the spec. Ask nothing new.
- **Open feature.** An idea or a source doc, one feature, questions still open. Run research, then plan only on GO.

## Fog — the map

Name the destination in one or two lines (a spec, a decision, or a change). Write `work/maps/{slug}.md`:

```markdown
## Destination
## Decisions so far
## Not yet specified
## Out of scope
```

Each open decision is its own note under `work/maps/{slug}/` with `## Question` and a type: research, prototype, grilling, or task. A question that cannot be phrased sharply stays under Not yet specified. Work past the destination goes under Out of scope.

Grilling and prototype decisions need the user in the loop. Research can run without them. Record the answer on the decision, gist it in Decisions so far, and graduate any fog that is now a sharp question.

If charting shows the whole route is already clear, drop the map and use the open-feature path.

## Settled — the spec

Explore the code. Use words from `GLOSSARY.md` when it exists. Prefer an existing public boundary for tests. List the seams, each with what it catches and what it misses, and confirm them with the user before publishing.

Write `work/{slug}/plan/SPEC.md`:

```markdown
## Problem statement
## Solution
## User stories
## Implementation decisions
## Testing decisions
## Out of scope
## Seams
```

User stories are numbered: As a <actor>, I want <feature>, so that <benefit>. Implementation decisions name modules, interfaces, schema, and API contracts. Leave out file paths and code. Testing decisions name the public behavior and the prior tests to copy. Publish to the issue tracker from `docs/agents/issue-tracker.md` when that file exists, labelled `ready-for-agent`.

## Open feature — research, then plan

Create `work/{slug}/REQUEST.md` from the user's idea or source doc: goal, who it is for, constraints, and the source links.

Read `REQUEST.md` and any project principles. If a requirement is ambiguous, stop and ask. Then write `work/{slug}/research/RESEARCH.md` with:

- Product value and who is hurt if this ships or does not
- What the code already does (from reading it)
- Feasibility, risks, and the approach: build, reuse, or decline
- A single line: `Verdict: GO` or `Verdict: CONDITIONAL` or `Verdict: NO-GO`
- The condition, when the verdict is CONDITIONAL

Stop on NO-GO. State the reason and the smallest change that would reopen it.

On GO or an accepted CONDITIONAL, lock decisions before the plan. Write `work/{slug}/CONTEXT.md`: choices already made, error behavior, and out of scope. A screen also follows `designing-interface` and writes `plan/ux.md`.

Then write:

- `work/{slug}/plan/pm.md` — stories and acceptance checks, each with a requirement id
- `work/{slug}/plan/eng.md` — boundaries, data, contracts, seams
- `work/{slug}/plan/PLAN.md` — tasks in waves

Each task is one `REQ-` id:

```markdown
- [ ] T1 | REQ-1 | files | change | verify command
```

Tasks in one wave must not edit the same file. A task without a verify command is not a task. The plan does not add work `CONTEXT.md` marked out of scope.

## Done

`RESEARCH.md` contains a verdict line, or a settled `SPEC.md` exists with seams the user confirmed. `PLAN.md` exists only after GO or a settled spec, and only after `CONTEXT.md` when the path was an open feature. The next session can execute T1 without a new product decision.
