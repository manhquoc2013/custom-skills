---
name: c-skill
disable-model-invocation: true
description: >-
  Use when writing or editing a skill, an AGENTS.md, or any document an agent
  reads: context pointers, the two loads, the information hierarchy, leading
  words, and pruning.
---

# Writing for agents

The packaging differs between a skill, an `AGENTS.md`, and a doc behind a pointer. The writing does not.

## Context pointers

A pointer names material held outside context and the condition for reaching it. A skill's `description` is one; a line naming a doc is the same object. Its wording, not its target, decides whether the agent ever arrives. Every word is always-loaded, so it earns harder pruning than the body: front-load the leading word, keep one trigger per branch, drop identity the body already carries.

## The two loads

- **Context load** — always-loaded text, spent every turn whether or not it fires.
- **Cognitive load** — the human remembering which document to reach for. Not a cost to minimise; it is the price of human agency.

Material behind a pointer escapes context load at the price of the pointer's own line.

## Information hierarchy

Steps first, then in-file reference, then disclosed reference behind a pointer. **Progressive disclosure** is the move down the ladder: inline what every branch needs, disclose what only some branches reach. **Co-location** keeps a concept's definition, rules, and caveats under one heading rather than scattered. **Sprawl** — a document too long even when every line is live — is cured by the ladder.

## Completion criteria

Each step ends on a bound the agent can check. **Clarity** stops premature completion, so sharpen the bound before hiding the later steps. **Demand** sets the legwork: "every modified model accounted for" forces more than "produce a change list".

## Leading words

One pretrained word beats a spelled-out triad and anchors the same behaviour wherever it appears: "fast, deterministic, low-overhead" collapses to *tight*. Reach for an existing word first — a coined one pays in definition tokens what a known word gives free.

**Negation is the failure mode beside this lever.** A prohibition drags the forbidden behaviour into context and makes it more available. Prompt the positive. Keep a prohibition only as a hard guardrail you cannot phrase positively, and pair it with the target.

## Pruning

- One meaning, one place. Duplication costs maintenance and inflates a meaning past its real rank.
- The environment is a source of truth too: a document restating a lookup is a cache. Cache only what the agent cannot find by looking.
- Hunt **no-ops** sentence by sentence: an instruction the model already obeys pays load to say nothing. Delete the sentence rather than trim its words.
- Without this discipline the default is **sediment**: stale layers that settle because adding feels safe and removing feels risky.

## Done

The body states its steps or its rules, not the two muddled; the description carries one trigger per branch; no meaning appears twice; no sentence survives that the model would obey by default.
