---
name: running-the-loop
description: >-
  Use when the user wants a recurring agent loop, daily triage, CI sweeper,
  PR babysitter, dependency sweep, changelog draft, post-merge cleanup, or to
  run until a goal with state, a budget, and a stop. Use for loop-engineering,
  /loop, Automations, STATE.md, or L1/L2/L3.
---

# Running the loop

A loop replaces the human as the prompter. It discovers work, assigns it, checks the result, and writes state. Week one reports. It does not merge.

## Pick one pattern

| What hurts | Pattern | First week |
|------------|---------|------------|
| Morning pile, noisy issues | Daily triage | L1, daily |
| PRs stalling | PR babysitter | L1 watch |
| CI red | CI sweeper | L2 only after a week of accurate reports; cadence 15m or slower |
| Dependency or CVE noise | Dependency sweeper | Patch-only, majors escalate |
| Stale release notes | Changelog drafter | L1 draft |
| TODO debt after merges | Post-merge cleanup | L1, off-peak |
| One named change to finish in this session | Not a cadence loop | `processing-the-flow` |

One primary loop per concern. Triage reports. Action loops execute. Pause dependency work while the default branch is red.

Feature and refactor work is a queue of small slices, not one unattended rewrite. Each slice is one worktree, one PR, one verifier, human merge until an allowlist has earned a wider scope.

## Readiness

| Level | Behavior | Required |
|-------|----------|----------|
| L0 | Intent written | Goal and non-goals |
| L1 | Report, no edits | Triage format, state file |
| L2 | Small fixes | Separate verifier, attempt cap, denylist |
| L3 | Unattended | Budget, run log, kill switch, the L2 verifier right for a week |

`npx @cobusgreyling/loop init` does not scaffold Cursor. Copy the files below and schedule with a Cursor Automation, or run the prompt by hand. `npx @cobusgreyling/loop doctor .` scores the result when the CLI is available.

## Files

`LOOP.md` — goal, non-goals, watched scope, cadence, level, denylist, kill switch.

`loop-budget.md` — daily cap, max attempts per item (3), max auto-PRs per day. The loop does not raise its own cap.

`loop-run-log.md` — append one block per run: start time, items seen, actions, escalations.

`STATE.md`:

```markdown
# STATE
## Level
## High priority
- item | suggested action | attempts
## Watch
## Waiting on human
## Last run
## Kill switch
paused: false
```

Every run reads `STATE.md` first and deletes lines whose PR or issue is already closed.

## One run

1. Exit immediately when the kill switch is paused or the budget cap is spent.
2. Triage into the state sections. One line per item. A line that needs a paragraph is two items or an escalation.
3. At L1, stop after the state write.
4. At L2, take one High priority item into a worktree. The implementer edits only that slice.
5. A second pass runs the project tests and rejects on failure, flake-looking retries, or a denylist path. Same-session self-approval does not count.
6. On the third failed attempt, move the item to Waiting on human with the last command output.
7. Append the run log. Notify only when a human must decide.

## Coordination

Read and follow `coordinating-agents`. The worker that writes `STATE.md` does not verify it. The verifier checks the schema and, at L1, that product code was not edited. An L2 fix is a separate worker whose `owns` cell is that slice. The run is done only when the verifier row is `pass`.

## Done

`LOOP.md` names the level and the non-goals, `STATE.md` matches the schema, and an L1 loop has not edited product code.
