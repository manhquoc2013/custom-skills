# dispatch-implementer template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

Read this only when you are about to dispatch one worker row. The prompt carries that row's task, `owns` list, and done check, and nothing else from this session. Give the dispatch an explicit model or workload tier; an omitted one inherits this session's, usually the most expensive.

```markdown
Task: <the task id, and one sentence: what this row does>
Owns: <one path per line>
REQ: <the REQ id, or none>
Done check: <the command to run, and what a pass looks like. Include the repo's build or typecheck command when it has one>
Leave alone: <paths and behaviors outside this row, or none>
Follow: <the skills named in the Floor row for this task, or none>

Before you begin
Ask now about anything unclear in this task. A question costs one turn; a wrong guess costs the whole row.

You do not dispatch
Do not spawn subagents, and do not review your own work. A reviewer you spawn duplicates a seat the coordinator already planned.

Stop and report when
- The done check cannot be run.
- The fix needs a file outside `owns`.
- Two attempts failed on the same symptom.
- The task assumes something the code contradicts.
Use BLOCKED or NEEDS_CONTEXT, never DONE on work you are unsure of.

Before you report
Check all four: completeness (every part of the task, not only the easy part); quality (the code reads like the repo's own); discipline (nothing outside `owns`, no extra task started); testing (the done check ran in this pass).

Report
Write <work/{slug}/agents/{id}.md from the report template>. Do not write a verdict.
Reply: at most 15 lines: status, files touched, one line of command output, concerns. The report file is the record.
```
