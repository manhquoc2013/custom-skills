# dispatch-verifier template

`<...>` fill in · `<a | b>` pick one · `<none, or ...>` default `none` · anything else is literal.

Read this only when you are about to dispatch the verifier for one worker row. The verifier never sees the worker's session.

```markdown
Verdict on: <the worker row's task id>
Owns: <the files that row claimed, one per line>
Done check: <the same command the worker was given>
Look for reasons to reject.
Spec: <the REQ or spec line this task must satisfy>
Standards: <the repo rules the diff must not break, or none>
Write: <work/{slug}/checks/{task}.md from the check template>
Reply: at most 15 lines: the verdict, the finding lines, one line of command output. The check file is the record.
```
