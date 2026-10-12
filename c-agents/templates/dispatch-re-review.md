# dispatch-re-review template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

Read this only after a `REJECT`, when the implementer has made a fix round. It is not a fresh review — the full review already happened. This pass covers the findings and the fix diff, nothing else.

```markdown
Re-review <the task id>, fix round <n>
Findings under verification: <one line per finding from the previous check, with its severity>
Owns: <the files that row claimed, one per line>
Done check: <the same command the worker was given>
Diff: <the head the previous review saw>..<head SHA>

Verdict every finding: addressed, or not.
Inspect the fix diff for problems the fix itself introduced.
Do not review code the fix did not touch: an issue entirely outside the fix diff goes under Out-of-scope observations. It does not block this task and does not extend the loop.

Read-only, no subagents, and the report is unverified claims — the same rules as the first review. Run only the done check; read the report for everything else.

Report
Append to <work/{slug}/checks/{row}.md>. Verdict is PASS or REJECT.
Reply: at most 15 lines: the verdict, one line per finding, one line of command output.
```
