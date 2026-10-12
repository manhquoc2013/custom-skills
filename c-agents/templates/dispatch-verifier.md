# dispatch-verifier template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

Read this only when you are about to dispatch the verifier for one worker row. The verifier never sees the worker's session. Give the dispatch an explicit model or workload tier; an omitted one inherits this session's, usually the most expensive.

```markdown
Verdict on: <the worker row's id>
Owns: <the files that row claimed, one per line>
Done check: <the same command the worker was given>
Spec: <the REQ or spec line this task must satisfy>
Standards: <the repo rules the diff must not break, or none>
Diff: <base SHA>..<head SHA>, or the path of the file holding it

Read the diff once. Its context lines are the changed files: do not open a changed file again unless a hunk you must judge is cut off mid-function, and say so when it is. Do not re-run git commands. Do not crawl the codebase: look outside the diff only for a risk you can name, one focused check per named risk, and name both the risk and what you checked.

Your review is read-only. Do not change the working tree, the index, HEAD, or the branch.

Do not trust the report. The implementer's report is unverified claims about the code, and a stated rationale — "kept it simple", "left it per YAGNI" — is the implementer grading its own work. A rationale never lowers a finding's severity.

Do not dispatch subagents. Do all of this yourself. A reviewer you spawn duplicates a seat that already exists, and its verdict counts for nothing. If the diff is too large for one pass, review it in passes and say so.

Tests: run the done check in this pass — that one run is what this gate requires. Read the report for every other command. Run one more only when reading the code raises a doubt no existing output answers, and then a focused test, never a package-wide suite.

Part 1 — spec compliance
- Missing: a requirement skipped, missed, or claimed but not built.
- Extra: work that was not requested.
- Misunderstood: the right feature built the wrong way.
- A requirement you cannot judge from this diff is a gap in your report, not a reason to widen the search.

Part 2 — code quality
Separation of concerns, error handling, edge cases; tests that verify behavior rather than mocks.
Compare every file the diff touches against `Owns` and list each file outside it under `Outside`. A file outside `owns` is a REJECT.
Do not crawl the broader codebase. Open a file outside the diff only to judge a risk you can name, and name that risk.

Report
Write <work/{slug}/checks/{row}.md from the check template>. Verdict is PASS or REJECT.
Every finding carries a severity: Critical (a break or a security hole), Important (wrong behavior, or a missing requirement), Minor (a smell the repo's own standard allows — a note, never a REJECT on its own).
Reply: at most 15 lines: the verdict, the finding lines, one line of command output. The check file is the record.
```
