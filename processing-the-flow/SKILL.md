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

A bug starts with a failing test that reproduces the reported cause. No production edit before that test fails.

## Superpowers

At each gate, read that Superpowers skill and follow it before doing the gate's own work. Say the skill name, then follow it. This pack still decides when a gate is done.

| Gate | Read and follow |
|------|-----------------|
| discuss, after the `REQ-` list is confirmed | `brainstorming` — approaches, design, user approval |
| plan | `writing-plans` |
| first execute | `using-git-worktrees` |
| each task | `test-driven-development`, then `requesting-code-review` |
| tasks in one wave that do not share files | `subagent-driven-development` |
| tasks that share files | `executing-plans` |
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

## Intake

Do this before research, plan, or code. A slot counts only when the user wrote it or confirmed it in this conversation. A guess written by the agent does not count.

Show the slots the prompt already fills, then ask the empty ones in the same message. Where the repo already has a fact (test command, screen name, design file), offer that fact as the recommended answer and wait for a yes.

Required slots:

| Slot | The user's answer states |
|------|--------------------------|
| Outcome | What is true when this work is finished |
| Actor | Who performs it |
| Behavior | The main path, including the input |
| Failure | The main error, empty, or forbidden case |
| Out of scope | What this work will not do |
| Verify | The command, screen action, or example that proves it |
| Source | A doc or ticket path, or that this prompt is the only source |

A screen adds two slots: which screen, and which existing visual system to follow, or none. A bug adds two slots: how to reproduce it, and the actual result versus the expected result.

Each distinct behavior the user names is its own requirement. Do not merge two behaviors into one line.

After the slots are filled, show the list and wait:

```markdown
- REQ-1 | <behavior or failure> | <expected result>
```

The list is locked when the user says it is complete. Add any behavior they add and show the list again. Then write `work/{slug}/CONTEXT.md` with the slots plus this list. Set `Stop` to `none` and start plan. An empty slot, or an unconfirmed list, keeps `Stop` at `needs-human`.

## Gates

| Phase | Write | Advance when |
|-------|--------|----------------|
| discuss | `CONTEXT.md` with every slot and a user-confirmed `REQ-` list. A screen also follows `designing-interface` | The user has confirmed the requirement list is complete |
| plan | `specifying-a-feature` writes research and `PLAN.md` | Plan check below passes |
| execute | `implementing-from-spec` for the current task only | Logic check returns `Verdict: PASS` |
| verify | `VERIFICATION.md` | Every `REQ-` id has a command whose result matches the expected result, and Gaps is empty |
| ship | PR link, or the commit message left in `IMPLEMENT.md` | Verify verdict is PASS |

On `PASS`, set `Attempt` to 0 and start the next task, then the next wave, then verify. On `REJECT`, stay, add 1 to `Attempt`, and fix from the Breaks or Gaps list. At attempt 3, set `Stop` to `attempt-cap`.

After discuss is locked, work on a feature branch. Unrelated dirty files set `Stop` to `needs-human`.

## Plan check

Reject `PLAN.md` before any execute when a `REQ-` id has no task, a task has no `REQ-` id or no verify command, two tasks in one wave edit the same file, a task covers more than one requirement, or the plan adds work `CONTEXT.md` marked out of scope.

## Logic check

After every task, write `work/{slug}/checks/{task}.md`. The verdict follows the command output.

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
