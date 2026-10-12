# Open feature — research, then plan

Create `work/{slug}/REQUEST.md` from `templates/request.md`.

Read `REQUEST.md` and any project principles. If a requirement is ambiguous, stop and ask. Then write `work/{slug}/research/RESEARCH.md` from `templates/research.md`.

Every Already or Touches claim cites a file and a symbol. Do not change frozen Requirements, Failure, or Out of scope. When a Touches behavior is missing from Kept, append that Kept row only after its command has been run and the output quoted. No such command: set `Stop` to `needs-human`. Do not add a `REQ-`.

Stop on NO-GO. State the reason and the smallest change that would reopen it.

On GO or an accepted CONDITIONAL, lock decisions before the plan. Write `work/{slug}/CONTEXT.md` with every heading from the CONTEXT template in `c-flow/templates/context.md`. A screen also follows `c-design` and writes `plan/ux.md`.

Then write:

- `work/{slug}/plan/pm.md` — stories and acceptance checks, each with a requirement id
- `work/{slug}/plan/eng.md` — boundaries, data, contracts, seams
- `work/{slug}/plan/PLAN.md` — tasks in waves

Each task is one `REQ-` id. Write `work/{slug}/plan/PLAN.md` from `templates/plan.md`.

A task is one behavior with its own test cycle. Fold setup into the task that needs it. A setup-only line is not a task. Tasks in one wave must not edit the same file. A task without a verify command is not a task. A task whose files already exist names the command that locks each public behavior this diff can change. `none` is allowed only when that seam has no public behavior yet. The plan does not add work `CONTEXT.md` marked out of scope.
