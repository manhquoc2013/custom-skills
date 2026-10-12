---
name: c-debug
description: >-
  Use when the user asks to debug, tìm lỗi, find a root cause, or fix a
  failure. Use for "debug", "tìm nguyên nhân", "sửa lỗi", "--find", "--fix".
---

# Debugging a failure

Find the cause before any repair. `--find` stops at the cause. `--fix` repairs only after that cause is quoted. Questions follow the Questions section of `c-agents`. If `systematic-debugging` or `diagnosing-bugs` is installed, follow its extra steps too. Neither one chooses the mode, and neither one starts a repair under `--find`.

## When another skill calls this

Another skill may enter only for a hard bug. A hard bug is a red command whose output does not name the line to edit, and the failure is not the missing behavior of a test just written for a new requirement.

Stay on the caller's own path for a syntax or parse error, a compiler line that names the file and the line, a lint or type diagnostic (`c-lint`), a missing import or symbol or file the tool names, or a new test that is red because that behavior is not written yet (`c-implement`). The user typing this skill is not this gate.

## Mode

The default mode is `--fix`. `--find` is only used when the user explicitly requests "chỉ tìm", "root cause", or `--find`. When neither word is present or when `c-flow` is the caller, the mode is `--fix`. Do not ask. Do not edit production code before the cause is proven and quoted in `CAUSE.md`.

## Loop

Redact secrets before showing any output. The user reports what they expected, what happened, and when it started. Do not ask them for the cause, the file, or the repair.

1. Build one red command: a failing test, a request, a CLI fixture, or a browser script, in that order. The command asserts the symptom the user named. A failure of a different symptom is the wrong bug. A flaky bug needs a higher reproduction rate before any hypothesis. If no red command can be built, stop and list what was tried. A command that goes red only because this session edited production code is not a repro. Revert that edit.
2. Shrink the repro until every remaining step is load-bearing. Re-run the command after each cut. A slow path that still returns the right result is `c-perf`, not this skill.
3. When a similar path stays green, or a known-good commit exists, name the one difference. When the failing frame received a bad value, trace that value to the first site that produced it.
4. Write 3 hypotheses, each with a prediction. A hypothesis with no prediction is discarded. Test the first. Change one variable. Tag a debug log `[DEBUG-<id>]`. Revert that change before the next hypothesis.
5. The cause is proven when one hypothesis predicts the red output and the other two are discarded by a command. Quote each command and its output. The cause names the site that produced the bad value, not the frame that reported it. A green result you cannot predict from that site is not proven.

## Find

`--find` writes `work/debug/CAUSE.md` and stops.

```markdown
## Mode
find
## Symptom
Expected:
Actual:
## Red command
Command:
Output:
## Working
the similar green path and the one difference, or none
## Cause
the site that first produced the bad value
## Discarded
### hypothesis
Command:
Output:
## Seam
where a regression test can fail on this symptom, or no seam
## Next
repair not started
```

It may add the red command's test. It does not change production code. Delete every `[DEBUG-<id>]` line and every throwaway harness that is not that test.

## Fix

`--fix` starts only after `CAUSE.md` has a quoted cause. `no seam` stops for a human. The repair is one failing test at that seam, then one edit at the site named in Cause. A guard at the reporting frame is not the repair. Re-run the original red command, not only the shrunk one. A repair that leaves that command red is reverted. Three reverted repairs, or a repair that moves the failure to a different symptom, stop for a human. A verifier is a separate pass and writes the verdict. Delete every `[DEBUG-<id>]` line before that pass. Do not start a second bug.
