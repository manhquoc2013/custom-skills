# Claiming done

Read this when the Floor row `About to claim pass, done, or fixed` matches, and before writing any claim of pass, done, or fixed. Check the claim against this table. A row that matches is a stop, not a caveat to add.

| Claim | Needs | Not enough |
|-------|-------|------------|
| The task passes | The done check run in this pass, output quoted | An earlier run, or "should pass" |
| The suite is green | The kept command run in this pass | A green suite alone |
| A bug is fixed | The original symptom re-run and passing | The code changed |
| A regression test works | The red-green cycle seen | The test passing once |
| A worker finished | The diff shows the changes | The worker's own "success" report |
| Every requirement is met | A line-by-line checklist against the `REQ-` list | The tests passing |

| Excuse | Reality |
|--------|---------|
| "Should work now" | Run it |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "The linter passed" | The linter is not the compiler |
| "The worker said success" | Read the diff |
| "A partial check is enough" | A partial check proves nothing |
| "I'm tired, ship it" | Exhaustion is not evidence |
