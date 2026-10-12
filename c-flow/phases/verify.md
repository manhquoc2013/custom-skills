## Logic check

The verifier for that task writes `work/{slug}/checks/{task}.md`, from `templates/check.md`. The implementer does not. The verdict follows the command output. Every finding the verifier reports carries a severity: Critical, Important, or Minor.

`REJECT` when Breaks is non-empty, Kept is missing, a Kept command was not run in this check, a Kept output disagrees with its quoted prior result, Outside is non-empty, the diff exports a name other than the task's produces line, the task verify command did not run, the expected result was paraphrased instead of quoted, or a screen changed and that flow was not exercised in the browser. The author of the code does not assign `PASS`. Otherwise `PASS`.

A `Minor` finding is a note in the check; on its own it does not make the verdict `REJECT`. On `REJECT`, the parent re-dispatches that implementer with the finding list, then dispatches a re-review from `c-agents/templates/dispatch-re-review.md`, scoped to those findings and the fix diff — never a fresh full review.

## Verify

Write `work/{slug}/VERIFICATION.md` from `templates/verify.md`.

`PASS` only when every `REQ-` id has a matching actual output, every Kept actual output matches its prior result, and Gaps and Outside are empty. A green suite with a gap is `REJECT`. The full check's test and build commands must both appear in `VERIFICATION.md` with their output; one of them missing is a gap.
