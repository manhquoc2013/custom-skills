After discuss is locked, work on a feature branch. Unrelated dirty files set `Stop` to `needs-human`.

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

On a wave `PASS`, the parent commits each passing task, or writes its commit message in `IMPLEMENT.md` when this session cannot commit. Set `Attempt` to 0 and dispatch the next wave. After the last wave passes, start verify. On `REJECT`, stay on that task, add 1 to `Attempt`, and re-dispatch only the failing task. At attempt 3, set `Stop` to `attempt-cap`.
