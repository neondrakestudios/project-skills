---
status: Accepted
date: 2026-10-22
supersedes: ADR-0001
superseded-by:
---

# ADR-0009: Two sibling vaults, the docs vault optional

## Context
ADR-0001 gave every scaffolded repo two vaults. A small project — a single piece of furniture, a one-off build — has little documentation to keep, and a novel's reference material belongs beside the manuscript in its own tool, and an empty `docs/` vault with ADR, requirements and guides folders is overhead nobody maintains.

## Decision
Scaffolded repos always get `context/`, rewritten in place forever. `docs/` is optional, recorded as `**Docs vault:**` in `CLAUDE.md`; the kind sets the default (`software` yes, `cad` ask, `writing` no) and `docs=` overrides it. When `docs/` exists, ADR-0001's rules hold: the two are siblings at the root, never nested; `docs/` is immutable once accepted, with changes as superseding ADRs; context links to docs only with relative Markdown links; docs never link to context; wikilinks, canvases and maps of content live only in `docs/`. Without `docs/`, decisions are rows in `context/DECISIONS.md` with their reason; a changed decision replaces its row, and git keeps the history.

## Consequences
The generated `CLAUDE.md`, `DECISIONS.md`, `PROJECT_STATE.md` and `.gitignore` render differently without `docs/`, through the `docs` flag. A repo's docs choice is fixed once scaffolded; adding `docs/` later is a manual change, not a re-run.

## Alternatives considered
Always both vaults — ADR-0001, too heavy for small projects. Docs as a stack — stacks can't remove the base rules that refer to `docs/`.
