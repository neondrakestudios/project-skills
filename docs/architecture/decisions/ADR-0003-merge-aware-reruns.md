---
status: Accepted
date: 2026-09-28
supersedes:
superseded-by:
---

# ADR-0003: Merge-aware, idempotent re-runs

## Context
The skill is re-run as templates evolve and over repos that already have a `CLAUDE.md`. Overwriting loses user edits; re-adding every missing section resurrects sections the user removed on purpose.

## Decision
Never overwrite an existing file; create any file the resolved templates have and the repo lacks, even one deleted earlier, because a deliberate deletion and a file new to the template look the same. The chosen stacks and org source are recorded on `**Stacks:**` and `**Org templates:**` lines in the generated `CLAUDE.md`; their presence marks a repo as scaffolded, and re-runs read them instead of asking or keeping a state file. On a never-scaffolded `CLAUDE.md`, missing sections are appended and clashing ones reported. On a scaffolded repo, missing or changed policy sections are reported, never added. Existing files are edited only to add missing `.gitignore` lines and the fragments of a newly chosen stack. Headings match case-insensitively and by prefix; any git or branch heading counts as the git section.

## Consequences
A second run with the same inputs changes nothing. Template changes reach existing repos only as reported differences the user applies. `dry-run` shows the effect without writing.

## Alternatives considered
Section-level upsert — breaks idempotence against deliberate deletions. A hidden state file — a second source of truth beside `CLAUDE.md`.
