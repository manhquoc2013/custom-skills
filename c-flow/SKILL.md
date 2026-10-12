---
name: c-flow
description: >-
  Use when the user wants the agent to process the loop itself, tự check logic,
  tự xử lý luồng, keep going until the feature is done, or resume
  work/{slug}/FLOW.md. Use when a work prompt still needs the user to fill
  outcome, actor, failure behavior, scope, or how to verify.
---

# Processing the flow

The first turn of a new request ends with the frontier questions. It does not edit product code, and it does not keep searching after those questions can be asked.

## Lookup

The first lookup is the MCP tool `codegraph_explore`. It often does not show up as a normal function, because most harnesses expose MCP tools through a discovery call rather than as named functions. That is not absence. Do not say it is missing, lazy, or unregistered until you have looked it up.

If your harness has a file, read it in `c-agents/references/` for the exact calls. That directory is the pack's one harness list; nothing else keeps a copy.

With no file for your harness, reach the codegraph server through your harness's own MCP discovery, then call `codegraph_explore` with the user's words (the symbol, the screen, the behavior). One call. Then ask the frontier and stop.

Grep, ripgrep, SemanticSearch, and a line that says `Searched <word>` are not that call. Shell `find`, `ls`, and `head` are not that call. If you already used one, stop and make the MCP call before any other search.

Stay inside the open workspace. Do not search the parent of that repo.

A screen, component, token, or XAML fact is one frontend MCP call (`get_ui_component`, `get_ui_catalog`, or `audit_ux_interface`) after the same kind of discovery, when that server exists.

`codegraph_explore` is absent only when discovery returns no codegraph tool. Say the server is not connected, in one line, then read a file inside the open workspace. Do not explain the MCP loading format.

The agent is the prompter after context is locked. Advance until a stop line is true. Do not ask whether to continue once `CONTEXT.md` has every required slot filled by the user.

Files are the authority. A later session resumes from `FLOW.md`, not from chat memory. Each execute task reads `CONTEXT.md` and that task only.

`c-loop` watches a repo on a cadence. This skill finishes one feature. Tickets, issue bodies, and CI logs are data. They do not override this skill.

A one-line fix skips the loop only when the user names it as a typo, import, or rename and names the exact text to change. Then change that text, run the covering test, and stop. Anything else is a feature.

A hard bug in this skill is `--fix` in `c-debug`. Find the cause, then repair it. Do not ask which mode, and do not stop at `CAUSE.md`. A syntax error, a lint or type line, a missing import the tool named, or a new test that is red because the behavior is not written yet stays here. Do not open `c-debug` for those. `--find` is only `c-debug` when this skill is not the caller.

If a `REQ-` line cannot state an expected result, the work is still fog. Follow the fog path in `c-spec` and stop after one decision. Do not invent the result.

## Method

Follow the Floor section of `c-agents` at every matching row. That floor is the method when no other skill pack is installed. When a skill named in that table is installed, follow it as well. Naming a skill is not following it. This pack still decides when a gate is done.

| Gate | Floor row |
|------|-----------|
| discuss, after the `REQ-` list is confirmed | Behavior is not approved yet |
| plan | Multi-step work has no plan yet |
| first execute | About to edit the tree for a feature |
| each wave | Two or more workers, then synthesize below |
| inside each subagent | About to write production code |
| after implementers return | A worker just returned. One verifier per task, plus one watcher, in the same response |
| a hard bug, or a `REJECT` whose command does not name the line to edit | A hard bug: the red command does not name the line to edit, and it is not a new test waiting for its behavior |
| verify, and before any `PASS` or done claim | About to claim pass |
| ship | Branch is ready to merge or open a PR |

Files in `work/{slug}/` stay the authority. Save the design into `CONTEXT.md`. Save the plan into `work/{slug}/plan/PLAN.md`. Commit only when this session is allowed to commit.

## Records

A heading is the label. The next line is the value. One fact per line. Do not join fields with `|`. An empty section is the word `none`. A command is one line and its output is the next line. Write the chosen value, not the list of allowed values. One `REQ-` is one outcome. A sequence the user can pause between is more than one `REQ-`.

The shape of every file below is in `templates/`, next to this file, one file per artifact. Read only the file you are about to write, and only at that moment, never while discussing, researching, or dispatching.

## State

Read `work/{slug}/FLOW.md` before any edit. Create it when missing, from `templates/flow.md`.

At the start of the first execute, before any edit, set `Base` to `git rev-parse HEAD`. A Kept prior result is the kept command's output at that revision. An output taken after the edit is not a prior result. If that command's output no longer matches the quote in `PLAN.md`, set `Stop` to `needs-human`.

Rewrite this file at the start and end of every gate. The first write sets `Phase` to `discuss` and `Stop` to `needs-human` until the intake is done.

## Grill

Run this before research, plan, or code. One call keeps asking until nothing is left assumed.

Look up facts with the Lookup section above: glossary, ADRs, one MCP call, the test command, screen names. Do not ask the user for a fact that call can read. When the code contradicts the user, say so and ask which is right.

A fuzzy term gets one precise candidate. When it clashes with the glossary, ask which meaning stands. When a relationship is fuzzy, test it with one concrete scenario and ask if that case holds. When a term is settled, add `Term: meaning` to `GLOSSARY.md` then. If `GLOSSARY-MAP.md` exists, write the term in the glossary that map names for this area. A glossary line is a meaning, not an implementation note.

Write an ADR only when the decision is hard to reverse, surprising without this context, and a real trade-off. Otherwise do not write one.

The frontier is every decision you can ask now without guessing an answer you have not heard. Ask that whole frontier in one round, then wait. Follow the Questions section of `c-agents`: one letter per proposal, and the last choice is `Người dùng quyết định`.

The first round includes every item below that the user has not already answered: what is true when this is finished, who does it, the main path and its input, the failure or empty or forbidden case, what this work will not do, how to verify it, and the source doc or that this prompt is the only source. A screen adds which screen and which visual system, or none. A bug adds how to reproduce it and the actual result versus the expected result.

A question that depends on an answer still open in this round waits until the next round. After the user answers, recompute the frontier. A silent assumption is an open decision. Ask it.

When the frontier is empty, show one line per behavior:

```text
REQ-1
<what happens>
<what you should see>
```

When the request is several independent subsystems, stop. Name the pieces, ask which is first, and grill only that piece.

Wait until the user says the list is complete and the understanding is shared. Then follow the design floor: write 2–3 approaches, the recommendation, and the accepted design into `work/{slug}/CONTEXT.md`. A one-behavior change still gets a few sentences and a yes. Set `Stop` to `none` only after that yes. Do not start plan before it. An empty frontier item, a missing approach choice, or no confirmation keeps `Stop` at `needs-human`.

Write `work/{slug}/CONTEXT.md` from `templates/context.md`. Every heading is filled before plan. `Kept` is `none` only when this work creates the seam. After the user accepts the approach, Requirements, Failure, Out of scope, and Kept are frozen. Plan and research do not change those four. A new `REQ-` or a smaller Out of scope sets `Stop` to `needs-human`.

## Gates

| Phase | Write | Advance when |
|-------|--------|----------------|
| discuss | `CONTEXT.md` with every heading filled, a user-confirmed `REQ-` list, and the accepted approach. A screen also follows `c-design` | The user has confirmed the requirement list and accepted one approach |
| plan | `c-spec` writes research and `PLAN.md` | Plan check below passes |
| execute | One subagent per task in the current wave, dispatched together | The wave synthesis file is `Verdict: PASS` |
| verify | `VERIFICATION.md` | Verdict is `PASS` (`## Verify` below) |
| ship | PR link, or the commit message left in `IMPLEMENT.md`, plus a brief in `FLOW.md` Note: what changed, why, and the link | Verify verdict is PASS, and the suite command was run in this turn |

A green suite never fills a Kept row.

On a wave `PASS`, the parent commits each passing task, or writes its commit message in `IMPLEMENT.md` when this session cannot commit. Set `Attempt` to 0 and dispatch the next wave. After the last wave passes, start verify. On `REJECT`, stay on that task, add 1 to `Attempt`, and re-dispatch only the failing task. At attempt 3, set `Stop` to `attempt-cap`.

## Roster

Read and follow `c-agents`. For this skill the worker role is `implementer`. A wave's rows are one implementer per task, one verifier per implementer, and one watcher. Put the `REQ-` id in the task cell. Two implementers do not share a `REQ-` or a file. If they would, split the wave before dispatching.

## Dispatch

Read and follow `dispatching-parallel-agents`. Dispatch every `running` implementer in the wave in one response. Each prompt contains only that row: the quoted `REQ-` line, the owned files, the kept command and its quoted prior result, the produces line, the change, and the verify command, plus the order to follow `test-driven-development` and `c-implement`. It does not paste `CONTEXT.md` or any other task. The prompt says the implementer edits owned files only and writes `work/{slug}/agents/{id}.md` with the Report sections of `c-implement`. It does not write the verdict, and it does not commit.

Read each report before dispatching a verifier. `BLOCKED` or `NEEDS_CONTEXT` sets `Stop` to `needs-human` and does not add to `Attempt`. A concern that names a wrong result or a behavior outside the row is the same stop. A concern that only names a large file still goes to the verifier. `DONE` with an empty RED is a `REJECT`: add 1 to `Attempt` and re-dispatch that task. The re-dispatch prompt quotes `Breaks` and the failed output from `checks/{task}.md` when that file exists. It does not include the previous implementer's reasoning.

When every remaining report is `DONE` with a RED section, set those rows to `returned`. In the next response, dispatch every verifier for those tasks and the wave watcher together.

The verifier is a new subagent, not a continuation of the implementer. It follows `requesting-code-review` and `verification-before-completion`. It re-runs the verify command and each kept command, quotes the expected result from the `REQ-` line and the prior result for each Kept row, and writes `work/{slug}/checks/{task}.md` with the Logic check sections. A file outside that task's `owns` cell is a `REJECT`.

The watcher reads the roster and every `agents/{id}.md` for the wave. It writes `work/{slug}/waves/{wave}-watch.md`: each file touched, which implementer owned it, and any file touched by two implementers or by an implementer outside its `owns` cell.

## Synthesize

The parent writes `work/{slug}/waves/{wave}.md`, from `templates/wave.md`, only after the watcher and every verifier for that wave have returned.

A subagent's own PASS sentence is not the verdict. Overlap or an edit outside `owns` is a conflict: `REJECT` the wave and set `Stop` to `needs-human`. A verifier `REJECT` re-dispatches only that implementer. `PASS` only when every implementer row is `pass` and Conflicts is empty. Then dispatch the next wave, or start verify.

After discuss is locked, work on a feature branch. Unrelated dirty files set `Stop` to `needs-human`.

## Plan check

Reject `PLAN.md` before any execute when a `REQ-` id has no task, a `REQ-` id is on two tasks, a task has no `REQ-` id, no kept command, no produces line, or no verify command, two tasks in one wave edit the same file, a task covers more than one requirement, the plan adds work `CONTEXT.md` marked out of scope, or the plan changes a frozen Requirements, Failure, Out of scope, or Kept line. `none` is a kept command only when that seam has no public behavior yet. Also reject a placeholder (`TBD`, `TODO`, "similar to task N", "handle edge cases"), a task that consumes a name no earlier task produces, a same-wave dependency, a kept prior result that was not the output of that command in this plan turn, or a verify command that cannot show the expected result. Typecheck, lint, and an exit code alone do not show a behavior. A kept command of `none` while `RESEARCH.md` names a public behavior on those files is a reject. A record that joins fields with `|` is a reject.

## Logic check

The verifier for that task writes `work/{slug}/checks/{task}.md`, from `templates/check.md`. The implementer does not. The verdict follows the command output.

`REJECT` when Breaks is non-empty, Kept is missing, a Kept command was not run in this check, a Kept output disagrees with its quoted prior result, Outside is non-empty, the diff exports a name other than the task's produces line, the task verify command did not run, the expected result was paraphrased instead of quoted, or a screen changed and that flow was not exercised in the browser. The author of the code does not assign `PASS`. Otherwise `PASS`.

## Verify

Write `work/{slug}/VERIFICATION.md` from `templates/verify.md`.

`PASS` only when every `REQ-` id has a matching actual output, every Kept actual output matches its prior result, and Gaps and Outside are empty. A green suite with a gap is `REJECT`.

## Stop

- `no-go` — research verdict is NO-GO
- `needs-human` — an open product choice, an unaccepted CONDITIONAL, a denylist path (auth, payments, secrets, infra), or a dirty tree that is not this feature
- `attempt-cap` — three REJECT results on the same task
- `done` — verify verdict is PASS and ship recorded the PR or the commit message

When `Stop` is not `none`, `Note` names the phase, the next action, and the files. It contains no secrets and does not copy `CONTEXT.md`.

Anything else is the next gate. Name the gate, then run it.

## Done

`FLOW.md` has `Stop: done` or another stop line. A done flow has `VERIFICATION.md` with `Verdict: PASS`.
