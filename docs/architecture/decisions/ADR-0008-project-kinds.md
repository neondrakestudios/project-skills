---
status: Accepted
date: 2026-10-22
supersedes:
superseded-by:
---

# ADR-0008: Project kinds — one kind overlay beneath the stacks

## Context
The base templates assumed software: `CONVENTIONS.md` before writing code, BDD testing, a session start that checks PRs and CI, a PR-only git workflow. A repo for a physical build — a loft bed designed in FreeCAD — or for a novel written in Obsidian wants the context system without those rules, and a novel needs a vault of its own for the manuscript. Stack overlays only append (ADR-0002), so no stack can take a base rule away.

## Decision
Every repo has exactly one kind, recorded as `**Kind:**` in `CLAUDE.md`. A kind is an overlay at `kinds/NAME/`, shaped and resolved like a stack overlay and applied before the stacks. Its `kind.md` sets the defaults for the docs vault and the git workflow, may declare further sibling vaults (`writing` declares `manuscript/`), fills kind-wide slots in the base files, and its `CLAUDE.md` fragment fills `{{kind_section}}`. The base templates are kind-neutral; what was software-only moved into `kinds/software/` or behind the `pull_requests` flag. Template files may hold conditional sections, `{{#flag}}…{{/flag}}` and `{{^flag}}…{{/flag}}`, on two flags: `docs` and `pull_requests`. Stacks declare their kind in `stack.md`, which only filters what the stack question offers. A repo scaffolded before kinds is `software`, and its kind never changes.

## Consequences
A software repo's generated `CLAUDE.md` keeps its policy text word for word, so re-runs over existing repos report no new differences there. Adding a kind is a directory, like adding a stack. A kind's vault follows ADR-0009's sibling rule: never nested, and linked from `context/` only by relative Markdown links. Template authors now read two flags when editing base files, and a policy section is compared on re-run only after its flags render.

## Alternatives considered
Non-code stacks only — the coding rules stay in every repo. A per-repo project override replacing `CLAUDE.md` and `CONVENTIONS.md` — works today, but every non-code repo would carry its own fork of the policy. Separate base templates per kind — duplicates the shared policy, which then drifts. For writing, the repo root as the vault — `context/` would nest inside it; the manuscript inside `docs/` — prose isn't immutable once accepted.
