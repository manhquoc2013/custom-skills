---
name: implementing-from-spec
description: >-
  Use when a feature has a GO verdict and a PLAN or SPEC, or the user says to
  implement a spec, ticket, or phase. Use when thêm chức năng and the spec
  already exists. Use before writing feature code that has a plan.
---

# Implementing from a spec

The plan is the scope. A session implements one task, then a separate check decides pass or fail. `CONTEXT.md` and that task are the authority. Chat memory is not.

## Load

Read `work/{slug}/CONTEXT.md` when it exists, then the current task in `PLAN.md` or `SPEC.md`. Read `GLOSSARY.md` when it exists. State the task name and its verify command before editing.

Missing plan: stop and follow `specifying-a-feature`. Missing GO on an open-feature folder: stop. A NO-GO folder stays unbuilt. A plan that fails the plan check in `processing-the-flow` stays unbuilt.

When `processing-the-flow` is the caller, the task's `REQ-` id is the seam. Do not ask again. Otherwise confirm the seams with the user when `SPEC.md` or `eng.md` has none confirmed. Tests are written only at those seams. The assertion's expected value is the expected result on that `REQ-` line.

## Slice

One public behavior.

1. Write one failing test at a confirmed seam. The expected value comes from the spec or a known example, not from reimplementing the function in the assertion.
2. Run it and see the failure.
3. Write only the code that makes that test pass.
4. Run the task's verify command.

Read and follow `test-driven-development` for the slice. Code written before the failing test is deleted and the slice starts again. On a failure, read and follow `systematic-debugging` before editing again. Before calling the task passed, read and follow `verification-before-completion`.

## Check

The session that wrote the code records evidence. It does not mark the task done.

A second pass, with instructions to find reasons to reject, runs the verify command and, when a screen changed, the app in the browser. The task passes when those commands succeed and the result matches the plan.

On failure, fix and re-check. After three failed checks on the same task, stop. Append the command output, the hypothesis, and the next human decision to `work/{slug}/implement/IMPLEMENT.md`.

## Record

Append to `work/{slug}/implement/IMPLEMENT.md`: task, seams, commands, pass or fail, and files touched. When this session is allowed to commit, one passing task is one commit. Otherwise write the commit message in that record. Denylist paths (auth, payments, secrets, infra) wait for human merge.

When `processing-the-flow` is the caller, return the verdict and let it start the next task. When this skill is the top-level request, stop after this task.

## Done

The task verify command passed on the second pass, the record names the commands, and no extra task was started by this skill.
