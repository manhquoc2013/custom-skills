---
name: processing-the-flow
description: >-
  Use when the user wants the agent to process the loop itself, tự check logic,
  tự xử lý luồng, keep going until the feature is done, or resume
  work/{slug}/FLOW.md. Use when a work prompt still needs the user to fill
  outcome, actor, failure behavior, scope, or how to verify.
---

# Processing the flow

The agent is the prompter after context is locked. Advance until a stop line is true. Do not ask whether to continue once `CONTEXT.md` has every required slot filled by the user.

Files are the authority. A later session resumes from `FLOW.md`, not from chat memory. Each execute task reads `CONTEXT.md` and that task only.

`running-the-loop` watches a repo on a cadence. This skill finishes one feature.

A one-line fix skips the loop only when the user names it as a typo, import, or rename and names the exact text to change. Then change that text, run the covering test, and stop. Anything else is a feature.

A bug starts as a tight loop. Before any hypothesis or production edit, run one command that goes red on the symptom the user described. Shrink that repro until every remaining step still makes it red. Then read `systematic-debugging`. If `diagnosing-bugs` is available, follow it for the loop.

If a `REQ-` line cannot state an expected result, the work is still fog. Follow the fog path in `specifying-a-feature` and stop after one decision. Do not invent the result.

## Superpowers

Read `coordinating-agents` and follow its situation table. The gate table is the order for this skill. Read each named skill and follow it. Naming it is not following it. This pack still decides when a gate is done.

| Gate | Read and follow |
|------|-----------------|
| discuss, after the `REQ-` list is confirmed | `brainstorming` — approaches, design, user approval |
| plan | `writing-plans` |
| first execute | `using-git-worktrees` |
| each wave | `dispatching-parallel-agents`, then synthesize below |
| inside each subagent | `test-driven-development` |
| after implementers return | one `verifier` subagent per task, plus one `watcher` for the wave, in the same response. Follow `requesting-code-review` inside each verifier |
| any `REJECT`, test failure, or bug | `systematic-debugging` before the next edit |
| verify, and before any `PASS` or done claim | `verification-before-completion` |
| ship | `finishing-a-development-branch` |

Files in `work/{slug}/` stay the authority. Save the design into `CONTEXT.md`. Save the plan into `work/{slug}/plan/PLAN.md` (this overrides the writing-plans default path). Write a Superpowers spec or plan file too when that skill requires one. Commit only when this session is allowed to commit.

## State

Read `work/{slug}/FLOW.md` before any edit. Create it when missing.

```markdown
# FLOW
## Goal
## Slug
## Phase
discuss | plan | execute | verify | ship | done
## Wave
## Task
## Attempt
0
## Last verdict
NONE | PASS | REJECT
## Stop
none | needs-human | no-go | attempt-cap | done
## Note
```

Rewrite this file at the start and end of every gate. The first write sets `Phase` to `discuss` and `Stop` to `needs-human` until the intake is done.

## Grill

Run this before research, plan, or code. One call keeps asking until nothing is left assumed.

Look up facts yourself: `GLOSSARY.md`, ADRs, code, the test command, screen names. Do not ask the user for a fact you can read. When the code contradicts the user, say so and ask which is right.

A fuzzy term gets one precise candidate. When it clashes with the glossary, ask which meaning stands. When a term is settled, add it to `GLOSSARY.md` then. A glossary line is a meaning, not an implementation note.

Write an ADR only when the decision is hard to reverse, surprising without this context, and a real trade-off. Otherwise do not write one.

The frontier is every decision you can ask now without guessing an answer you have not heard. Ask that whole frontier in one round, then wait.

```text
Q1. <title>
<question>
Recommended: <answer>. Yes accepts this.
```

The first round includes every item below that the user has not already answered: what is true when this is finished, who does it, the main path and its input, the failure or empty or forbidden case, what this work will not do, how to verify it, and the source doc or that this prompt is the only source. A screen adds which screen and which visual system, or none. A bug adds how to reproduce it and the actual result versus the expected result.

A question that depends on an answer still open in this round waits until the next round. After the user answers, recompute the frontier. A silent assumption is an open decision. Ask it.

When the frontier is empty, show one line per behavior:

```text
REQ-1 | <behavior or failure> | <expected result>
```

Wait until the user says the list is complete and the understanding is shared. Then write `work/{slug}/CONTEXT.md` and set `Stop` to `none`. Do not start plan before that sentence. An empty frontier item, or no confirmation, keeps `Stop` at `needs-human`.

## Gates

| Phase | Write | Advance when |
|-------|--------|----------------|
| discuss | `CONTEXT.md` with every slot and a user-confirmed `REQ-` list. A screen also follows `designing-interface` | The user has confirmed the requirement list is complete |
| plan | `specifying-a-feature` writes research and `PLAN.md` | Plan check below passes |
| execute | One subagent per task in the current wave, dispatched together | The wave synthesis file is `Verdict: PASS` |
| verify | `VERIFICATION.md` | Every `REQ-` id has a command whose result matches the expected result, and Gaps is empty |
| ship | PR link, or the commit message left in `IMPLEMENT.md` | Verify verdict is PASS |

On a wave `PASS`, set `Attempt` to 0 and dispatch the next wave. After the last wave passes, start verify. On `REJECT`, stay on that task, add 1 to `Attempt`, and re-dispatch only the failing task. At attempt 3, set `Stop` to `attempt-cap`.

## Roster

Read and follow `coordinating-agents`. For this skill the worker role is `implementer`. A wave's rows are one implementer per task, one verifier per implementer, and one watcher. Put the `REQ-` id in the task cell. Two implementers do not share a `REQ-` or a file. If they would, split the wave before dispatching.

## Dispatch

Read and follow `dispatching-parallel-agents`. Dispatch every `running` implementer in the wave in one response. Each prompt contains only that row: the quoted `REQ-` line, the owned files, the change, and the verify command, plus the order to follow `test-driven-development` and `implementing-from-spec`. The prompt says the implementer edits owned files only and writes `work/{slug}/agents/{id}.md` with the files it touched and the command output. It does not write the verdict.

When every implementer in the wave has returned, set those rows to `returned`. In the next response, dispatch every verifier for those tasks and the wave watcher together.

The verifier is a new subagent, not a continuation of the implementer. It follows `requesting-code-review` and `verification-before-completion`. It re-runs the verify command, quotes the expected result from the `REQ-` line, and writes `work/{slug}/checks/{task}.md`. A file outside that task's `owns` cell is a `REJECT`.

The watcher reads the roster and every `agents/{id}.md` for the wave. It writes `work/{slug}/waves/{wave}-watch.md`: each file touched, which implementer owned it, and any file touched by two implementers or by an implementer outside its `owns` cell.

## Synthesize

The parent writes `work/{slug}/waves/{wave}.md` only after the watcher and every verifier for that wave have returned.

```markdown
## Verdict
PASS or REJECT

## Tasks
id | role | REQ | owns | status | command | actual output | verdict

## Conflicts
from the watcher file

## Next
next wave id, or verify
```

A subagent's own PASS sentence is not the verdict. Overlap or an edit outside `owns` is a conflict: `REJECT` the wave and set `Stop` to `needs-human`. A verifier `REJECT` re-dispatches only that implementer. `PASS` only when every implementer row is `pass`, Conflicts is empty, and every actual output matches the quoted `REQ-` result. Then dispatch the next wave, or start verify.

After discuss is locked, work on a feature branch. Unrelated dirty files set `Stop` to `needs-human`.

## Plan check

Reject `PLAN.md` before any execute when a `REQ-` id has no task, a task has no `REQ-` id or no verify command, two tasks in one wave edit the same file, a task covers more than one requirement, or the plan adds work `CONTEXT.md` marked out of scope.

## Logic check

The verifier for that task writes `work/{slug}/checks/{task}.md`. The implementer does not. The verdict follows the command output.

```markdown
## Verdict
PASS or REJECT

## Branches
Each conditional, error path, and empty state this task touched.

## Evidence
For each branch: input, expected result quoted from that `REQ-` line, command, and the command's actual output.

## Breaks
A conditional in the task diff that is absent from Branches, a branch with no command, or an actual output that disagrees with the quoted expected result.
```

`REJECT` when Breaks is non-empty, the task verify command did not run, the expected result was paraphrased instead of quoted, or a screen changed and that flow was not exercised in the browser. The author of the code does not assign `PASS`. The verdict is `PASS` only when Breaks is empty.

## Verify

```markdown
## Verdict
PASS or REJECT

## Requirements
REQ-id | expected result quoted from CONTEXT.md | command | actual output

## Gaps
Any REQ-id with no row, or an actual output that disagrees with the quoted expected result.
```

A green suite with a gap is `REJECT`. `PASS` only when every `REQ-` id has a matching actual output and Gaps is empty.

## Stop

- `no-go` — research verdict is NO-GO
- `needs-human` — an open product choice, an unaccepted CONDITIONAL, a denylist path (auth, payments, secrets, infra), or a dirty tree that is not this feature
- `attempt-cap` — three REJECT results on the same task
- `done` — verify verdict is PASS and ship recorded the PR or the commit message

Anything else is the next gate. Name the gate, then run it.

## Done

`FLOW.md` has `Stop: done` or another stop line. A done flow has `VERIFICATION.md` with `Verdict: PASS`.
