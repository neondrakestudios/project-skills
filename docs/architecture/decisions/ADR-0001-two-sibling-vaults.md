---
status: Accepted
date: 2026-09-28
supersedes:
superseded-by:
---

# ADR-0001: Two sibling vaults with one-way links

## Context
Agent-facing current state and human documentation rot each other when mixed: live status goes stale inside documentation, and narrative bloats context files until they are too costly to load every session. Obsidian indexes every `.md` below a vault root, so one vault cannot keep the two apart.

## Decision
Scaffolded repos get two Obsidian vaults as siblings at the root, never nested: `context/` (rewritten in place forever) and `docs/` (immutable once accepted; changes are superseding ADRs). Context links to docs only with relative Markdown links; docs never link to context. Wikilinks, canvases and maps of content live only in `docs/`.

## Consequences
The docs graph never pulls in context notes, and no link breaks across the boundary. The context vault's Obsidian config inserts Markdown links, not wikilinks. The rules must be stated in each generated `CLAUDE.md`, because nothing else enforces them.

## Alternatives considered
One vault with folders — Obsidian's graph and link resolution would span both. Nested vaults — the outer vault indexes the inner one.
