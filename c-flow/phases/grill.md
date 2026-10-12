## Grill

Run this before research, plan, or code. One call keeps asking until nothing is left assumed.

Look up facts with the Lookup section of `c-flow/SKILL.md`: glossary, ADRs, one MCP call, the test command, screen names. Do not ask the user for a fact that call can read. When the code contradicts the user, say so and ask which is right.

A fuzzy term gets one precise candidate. When it clashes with the glossary, ask which meaning stands. When a relationship is fuzzy, test it with one concrete scenario and ask if that case holds. When a term is settled, add `Term: meaning` to `GLOSSARY.md` then. If `GLOSSARY-MAP.md` exists, write the term in the glossary that map names for this area. A glossary line is a meaning, not an implementation note.

Write an ADR only when the decision is hard to reverse, surprising without this context, and a real trade-off. Otherwise do not write one.

The frontier is every decision you can ask now without guessing an answer you have not heard. Ask that whole frontier in one round, then wait. Follow the Questions section of `c-agents`: one letter per proposal, and the last choice is `Người dùng quyết định`.

The first round includes every item below that the user has not already answered: what is true when this is finished, who does it, the main path and its input, the failure or empty or forbidden case, what this work will not do, how to verify it, and the source doc or that this prompt is the only source. A screen adds which screen and which visual system, or none. A bug adds how to reproduce it and the actual result versus the expected result.

A question that depends on an answer still open in this round waits until the next round. After the user answers, recompute the frontier. A silent assumption is an open decision. Ask it.

Play back as you go. As soon as one part is understood well enough to describe — what it is for and who it serves, or how one piece behaves — describe that part back in two or three sentences, then return to questions about the next part. Playback and questions alternate. Mark every guess as a guess: only what the user said goes into `CONTEXT.md`, and your inference goes in as an open decision.

Ask openly first; offer a short menu only when the user is stuck. Ask about anti-goals too — what would make this a failure even if it technically works — because that answer shapes `Failure` and `Out of scope` more than the goals do. When looking would settle a question, offer to look — the code call, the repo, the file — and say what you would look for; the user decides.

When the frontier is empty, show one line per behavior:

```text
REQ-1
<what happens>
<what you should see>
```

A `REQ-` whose expected result nobody can state as something a command or a person could observe is marked `unverifiable`, with one line saying what is missing:

```text
REQ-3
<what happens>
unverifiable: <what is missing>
```

It is still a requirement. It is never a `PASS`. Mark it here, while the user is present — a verifier cannot later tell a requirement it cannot check from one it checked and found fine.

When the request is several independent subsystems, stop. Name the pieces, ask which is first, and grill only that piece.

Wait until the user says the list is complete and the understanding is shared. Then follow the design floor: write 2–3 approaches, the recommendation, and the accepted design into `work/{slug}/CONTEXT.md`. A one-behavior change still gets a few sentences and a yes. Set `Stop` to `none` only after that yes. Do not start plan before it. An empty frontier item, a missing approach choice, or no confirmation keeps `Stop` at `needs-human`.

Write `work/{slug}/CONTEXT.md` from `templates/context.md`. Every heading is filled before plan. `Kept` is `none` only when this work creates the seam. After the user accepts the approach, Requirements, Failure, Out of scope, and Kept are frozen. Plan and research do not change those four. A new `REQ-` or a smaller Out of scope sets `Stop` to `needs-human`.
