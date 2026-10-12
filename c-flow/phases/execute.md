After discuss is locked, work on a feature branch. Unrelated dirty files set `Stop` to `needs-human`.

## Roster

Read and follow `c-agents`. For this skill the worker role is `implementer`. A wave's rows are one implementer per row and one verifier per row. Put the `REQ-` id, or the ids, in the task cell.

Two rows do not share a file. If they would, split the wave before dispatching.

**Batch same-shape tasks into one row.** The same-shape test is: several tasks that are each a small, independent edit of the same kind — the same one-line fix, a constant change, or a field addition repeated across files. Those are one row, not one row each: one dispatch lists every file and its change, and its diff is reviewed as one unit. Keep one task per row for work that needs its own judgment, its own tests, or its own review surface. Batching happens here, at dispatch; `PLAN.md` still holds one task per requirement.

## Dispatch

Read and follow `dispatching-parallel-agents`. Dispatch every `running` implementer in the wave in one response. Each prompt contains only that row: the quoted `REQ-` line, the owned files, the kept command and its quoted prior result, the produces line, the change, and the verify command, plus the order to follow `test-driven-development` and `c-implement`. It does not paste `CONTEXT.md` or any other task. The prompt says the implementer edits owned files only and writes `work/{slug}/agents/{id}.md` with the Report sections of `c-implement`. It does not write the verdict, and it does not commit.

Read each report before dispatching a verifier. `BLOCKED` or `NEEDS_CONTEXT` sets `Stop` to `needs-human` and does not add to `Attempt`. A concern that names a wrong result or a behavior outside the row is the same stop. A concern that only names a large file still goes to the verifier. `DONE` with an empty RED is a `REJECT`: add 1 to `Attempt` and re-dispatch that row. The re-dispatch prompt quotes `Breaks` and the failed output from `checks/{row}.md` when that file exists. It does not include the previous implementer's reasoning.

When every remaining report is `DONE` with a RED section, set those rows to `returned`. In the next response, dispatch every verifier for those rows together.

The verifier is a new subagent, not a continuation of the implementer. It follows `requesting-code-review` and `verification-before-completion`. It re-runs the verify command and each kept command, quotes the expected result from the `REQ-` line and the prior result for each Kept row, and writes `work/{slug}/checks/{row}.md` with the Logic check sections. It compares every file the diff touches against the row's `owns` cell and lists each file outside it under `Outside`. Any file outside `owns` is a `REJECT`.

## Synthesize

The parent writes `work/{slug}/waves/{wave}.md`, from `templates/wave.md`, only after every verifier for that wave has returned.

A subagent's own PASS sentence is not the verdict. **The parent computes overlap itself**: a file claimed by two rows is a conflict, however many tasks either row carries. The same file twice inside one row is not. Overlap or an edit outside `owns` is a conflict: `REJECT` the wave and set `Stop` to `needs-human`. A verifier `REJECT` re-dispatches only that implementer. `PASS` only when every implementer row is `pass` and Conflicts is empty. Then dispatch the next wave, or start verify.

On a wave `PASS`, the parent commits each passing task, or writes its commit message in `IMPLEMENT.md` when this session cannot commit. Set `Attempt` to 0 and dispatch the next wave. After the last wave passes, start verify. On `REJECT`, stay on that task, add 1 to `Attempt`, and re-dispatch only the failing task. At attempt 3, set `Stop` to `attempt-cap`.
