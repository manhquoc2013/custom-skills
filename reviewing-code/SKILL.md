---
name: reviewing-code
description: >-
  Use when the user asks to review code, review a PR, review a branch, or
  review since a commit. Use for "review code", "soi diff", "review PR".
  The review is read-only.
---

# Reviewing code

Read the diff. Do not edit it in this pass. Questions follow the Questions section of `coordinating-agents`.

## Pin the diff

The fixed point is the commit, branch, tag, or `main` the user named. When they name none, the recommended point is the merge-base with the repo's default branch. Confirm the ref with `git rev-parse`. The diff command is `git diff <fixed-point>...HEAD`. An unknown ref or an empty diff stops here.

Also list `git log <fixed-point>..HEAD --oneline`.

## Two axes

Dispatch both readers in one response. Each reader gets the diff command and the commit list, not this chat's history. Do not merge their findings into one ranked list.

**Spec.** What the change was asked to do: the `REQ-` lines, the issue named in the commits, or a spec path the user gave. Report missing or partial behavior, behavior nobody asked for, and behavior that looks present but wrong. Quote the spec line. A public behavior the diff can change, and that the spec does not name, is a finding. Name the command that locks the old result, or `no command`. No spec: this axis says `no spec` and stops.

**Standards.** Rules written in this repo (`AGENTS.md`, `CONTRIBUTING.md`, a standards file). A written rule can reject. On top of that, a judgement note only: a name that hides the job, the same logic twice in the diff, a string standing in for a domain value, or an abstraction the spec does not need. A written repo rule wins over that note. Skip anything the linter or typechecker already reports.

## Report

Write `work/review/REVIEW.md`. When a feature slug exists, write `work/{slug}/review/REVIEW.md` instead. Two headings, `## Spec` and `## Standards`, then one line each: finding count and the worst finding on that axis.

Applying a finding is a later pass. One finding, then the command that shows it is gone. A finding the repo's own standard allows is left as a note. Push back when the finding does not match the diff or the spec, and cite the line.
