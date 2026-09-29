---
status: Accepted
date: 2026-09-28
supersedes:
superseded-by:
---

# ADR-0002: Template layers — additive stacks, file-level overrides

## Context
Templates vary by stack, by GitHub org and by project. One repo can have several stacks. Merging fragments of Markdown from two authors depends on both keeping compatible structure, which fails silently.

## Decision
Four layers: bundle, stack overlays, org override, project override. Every layer is shaped like `templates/`. For any relative path — a base file or a single stack fragment — the most specific layer wins outright. Stack overlays are then applied additively onto whichever base file won: fragments at a base path are appended, other paths are new files. The only fragment-level override is `CLAUDE.append.md`, appended to `CLAUDE.md`. Available stacks are the union of `stacks/*/` across layers; no list exists anywhere else.

## Consequences
An org can replace one stack fragment or add a stack without forking the plugin. An org replacing a base file does not erase stack sections. The report must show each output's contributors, because the result can no longer be read from one directory.

## Alternatives considered
Applying overrides after stacks, as first specified — an overridden `CONVENTIONS.md` would silently drop every stack's sections. Fragment merging within overrides — rejected for surprise.
