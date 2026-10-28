---
status: Accepted
date: 2026-10-28
supersedes: ADR-0008
superseded-by:
---

# ADR-0010: Project kinds and named writing vaults

## Context
Kinds let the scaffold apply policies that fit software, physical builds and long-form writing without duplicating the common context system. The writing kind originally declared a sibling vault named `manuscript/`. Obsidian displays the opened folder's name in its vault switcher, so every generated writing project appeared as “manuscript”, making several projects hard to distinguish.

## Decision
Every repo has exactly one kind, recorded as `**Kind:**` in `CLAUDE.md`. A kind is an overlay at `kinds/NAME/`, shaped and resolved like a stack overlay and applied before the stacks. Its `kind.md` sets defaults for the docs vault and git workflow, may declare further sibling vaults and fills kind-wide slots in the base files. Base templates remain kind-neutral; kind-specific policy lives in the kind overlay, and stacks only add to it.

For a new writing scaffold, ask for the one root folder that Obsidian will open as the writing vault, suggesting the repository name. Record the accepted name as `**Writing vault:**` in the generated Writing section, and use that one value in every writing and StoryLine path, including ignore rules. Existing writing scaffolds with no recorded value keep `manuscript/` when it exists; a re-run never renames or creates a replacement vault.

## Consequences
Writing vaults have meaningful, distinct names in Obsidian while preserving a predictable folder name by default. The recorded value makes future runs and added StoryLine fragments consistent. The skill must validate the answer as one root folder name and report the legacy assumption for pre-existing writing scaffolds. The vault remains a sibling of `context/` and optional `docs/`, following ADR-0009.

## Alternatives considered
Keep `manuscript/` for every project — clear in the filesystem but ambiguous in Obsidian's vault switcher. Derive the folder silently from the repository name — predictable, but prevents an author from choosing an established book or series name. Use the repo root as the vault — would nest `context/` inside the Obsidian vault and weaken the separation of current agent state from the manuscript.
