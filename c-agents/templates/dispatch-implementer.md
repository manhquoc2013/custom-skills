# dispatch-implementer template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

Read this only when you are about to dispatch one worker row. The prompt carries that row's task, `owns` list, and done check, and nothing else from this session.

```markdown
Task: <the task id, and one sentence: what this row does>
Owns: <one path per line>
REQ: <the REQ id, or none>
Done check: <the command to run, and what a pass looks like>
Leave alone: <paths and behaviors outside this row, or none>
Report: write <work/{slug}/agents/{id}.md from the report template. Do not write a verdict.
Follow: <the skills named in the Floor row for this task, or none>
```
