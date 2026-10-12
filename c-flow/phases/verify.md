## Logic check

The verifier for that row writes `work/{slug}/checks/{row}.md`, from `templates/check.md`. A row that carries several tasks gets one `## Evidence` block per `REQ-`. The implementer does not. The verdict follows the command output. Every finding the verifier reports carries a severity: Critical, Important, or Minor.

`REJECT` when Breaks is non-empty, Kept is missing, a Kept command was not run in this check, a Kept output disagrees with its quoted prior result, Outside is non-empty, the diff exports a name other than the task's produces line, the task verify command did not run, the expected result was paraphrased instead of quoted, or a screen changed and that flow was not exercised in the browser. The author of the code does not assign `PASS`. Otherwise `PASS`.

A `Minor` finding is a note in the check; on its own it does not make the verdict `REJECT`. A `Critical` or `Important` finding that changes the verdict carries deterministic evidence: the exact command that failed when run in this check, with its output, or a command with output that reproduces the defect. A finding with neither is a note, not a `REJECT`, however well reasoned it sounds. This is what stops a re-check from reverting a green round on an unevidenced opinion. On `REJECT`, the parent re-dispatches that implementer with the finding list, then dispatches a re-review from `c-agents/templates/dispatch-re-review.md`, scoped to those findings and the fix diff — never a fresh full review.

## Verify

Write `work/{slug}/VERIFICATION.md` from `templates/verify.md`.

`PASS` only when every `REQ-` id has a matching actual output, every Kept actual output matches its prior result, and Gaps and Outside are empty. A green suite with a gap is `REJECT`. The full check's test and build commands must both appear in `VERIFICATION.md` with their output; one of them missing is a gap.

A `REQ-` marked `unverifiable` is neither `PASS` nor a silent gap. List it under Gaps with its reason and set `Stop` to `needs-human`. The verifier does not ask itself whether it is sure — it routes on the marker. A confident pass on a requirement nobody could check is the worst outcome there is, because nothing flags it and the run reads green.
