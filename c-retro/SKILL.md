---
name: c-retro
disable-model-invocation: true
argument-hint: [phiên | feature]
description: >-
  Retro after a session or a feature run. Proposes changes to the repo's
  environment, not the code.
---

# Retro

A retro changes the environment, not the product. The deliverable is a ranked list of candidates the user accepts or rejects. This pass edits no code.

## Steps

1. Name the session or the flow slug. With none named, take the current one, and read `work/{slug}/FLOW.md` plus the records under `work/{slug}/`.
2. Walk the categories below. Skip a category that produced nothing; do not pad it.
3. Rank by severity: a candidate that would have prevented a repeated failure outranks a nicety.
4. Present the list, then write the accepted ones to `work/retro/RETRO.md` from the template in `templates/retro.md`.

## Categories

### Navigation

Could the agent have found the right file faster? A missing pointer, or a hidden dependency between files, is the finding.

### Automated checks

Read the repo's own check command first, so a check that already exists but sits unwired or silently broken is the finding rather than a reinvention. A repo with no guardrail at all is itself a finding.

### Coding standards

Classify the violation first. A mechanical one — a banned API, an import shape, a file-location rule — gets a deterministic check, not a prose rule. Reserve standards text for genuine judgement calls. The reviewer carries the standards, not the implementer: the implementer has the most context pressure.

### Steering files

An instruction in `AGENTS.md` or a skill that does not change behaviour is a no-op: move it, or delete it.

### Tool economy

An expensive or token-hungry call that could be streamlined.

### Information access

A fact the agent could not see — logs, a read-only service, a doc.

## Done

Every candidate names its category, the evidence from this session, and the change that would prevent the failure. `work/retro/RETRO.md` holds the accepted ones.
