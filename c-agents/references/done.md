# Claiming done

Read this when the Floor row `About to claim pass, done, or fixed` matches, and before writing any claim of pass, done, or fixed.

**Evidence before the claim, always. Violating the letter of this rule is violating the spirit of it.**

## The gate

Before any status, and before any sentence that implies one:

1. Name the command that would prove the claim.
2. Run it now, in this turn, whole.
3. Read the full output and the exit code.
4. Say only what that output shows. Output that does not confirm the claim means the claim is not written.
5. Then write the claim, with the command and its output.

Skipping a step is not verifying. It is writing something untrue.

## What each claim needs

| Claim | Needs | Not enough |
|-------|-------|------------|
| The task passes | The done check run in this turn, output quoted | An earlier run, or "should pass" |
| The suite is green | The kept command run in this turn | A green suite alone |
| The build passes | The build command, exit 0 | A green linter |
| A bug is fixed | The original symptom re-run and passing | The code changed |
| A regression test works | The red-green cycle seen | The test passing once |
| A worker finished | The diff shows the changes | The worker's own "success" report |
| Every requirement is met | A line-by-line checklist against the `REQ-` list | The tests passing |

A run that showed a failure goes into the claim, named — including a failure this change did not cause. A red result that scrolled past and went unmentioned is a claim falsified by omission.

## The claim's wording

The rule covers the exact phrase, a paraphrase, a synonym, and the implication. Any wording that suggests the work is done, or that shows satisfaction with it, is a claim.

## Stop words

Any of these means stop and run the command:

- "should", "probably", "seems to", "looks correct"
- "Great", "Perfect", "Done" — any satisfaction before a run
- trusting a worker's success report
- a partial check
- "just this once"
- being tired and wanting it over
- any wording implying success without the run

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run it |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "The linter passed" | The linter is not the compiler |
| "The worker said success" | Read the diff |
| "A partial check is enough" | A partial check proves nothing |
| "I'm tired, ship it" | Exhaustion is not evidence |
| "Different words, so the rule does not apply" | The spirit is the rule |
