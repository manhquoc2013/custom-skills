# Settled — the spec

Explore the code. Read `GLOSSARY.md` and the ADRs under `docs/adr/` that touch this area. Use those words. A new term goes into `GLOSSARY.md`. A decision later work must obey goes into `docs/adr/` as the next number. Prefer an existing public boundary for tests. Each seam line says what it catches and what it misses. Implementation decisions name modules and contracts, not file paths. Confirm the seams with the user before publishing.

Write `work/{slug}/plan/SPEC.md` from `templates/spec.md`.

One story is one outcome, not a chain of steps. Implementation decisions name modules, interfaces, schema, and API contracts. Leave out file paths and code. Testing decisions name the public behavior and the prior tests to copy. Publish to the issue tracker from `docs/agents/issue-tracker.md` when that file exists, labelled `ready-for-agent`.
