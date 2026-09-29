# {{project_name}}

{{summary}}

## Where things live

This repo keeps two Obsidian vaults as siblings at the root. They are never nested.

| Root | Holds | Lifecycle |
|---|---|---|
| `context/` | Agent-facing current state, loaded every session | Rewritten in place for its whole life |
| `docs/` | Human documentation: ADRs, requirements, guides | Mutable while draft; immutable once published or accepted |

| File | Read it |
|---|---|
| `context/PROJECT_STATE.md` | At every session start |
| `context/CONVENTIONS.md` | Before writing code |
| `context/DECISIONS.md` | Before changing anything cross-cutting |
| `context/GLOSSARY.md` | When a term is unfamiliar |
| `docs/index.md` | When looking for documentation |
| `docs/architecture/decisions/` | When you need why, not what |

Retrieval is by name: this table, then grep.

## Session start

1. Read `context/PROJECT_STATE.md`.
2. Verify it against live state — `gh pr list --state open --base {{default_branch}}`, CI status, recent `git log`. The file reflects only its last manual edit. Where they disagree, live state wins; correct the file in your next PR.

## Classification rule

- **Context files** (`context/`) are rewritten in place for their whole life. They never accumulate.
- **Documentation files** (`docs/`) are mutable while in draft and immutable once published or accepted. A changed decision is a new ADR that supersedes the old one; the old ADR's status becomes `Superseded by ADR-NNNN` and nothing else in it changes.
- A draft is edited freely. The editable phase ends for documentation and never ends for context.

## Linking rule

Wikilinks are vault-scoped and cannot cross between `context/` and `docs/`.

- **context → docs:** relative Markdown links only, e.g. `[ADR-0012](../docs/architecture/decisions/ADR-0012-example.md)`. Never `[[wikilinks]]`.
- **docs → context:** never. Live status is not documentation's job.
- Wikilinks, `.canvas` files and maps of content live only in `docs/`.
- Keep `context/` files frontmatter-light; every line is loaded every session.

## Keeping PROJECT_STATE current

- **Same-PR rule:** update `context/PROJECT_STATE.md` in the same PR as the change that alters state, worded as it will read once merged. No separate "refresh state" PRs.
- Edit in place. It is never a session log: no transcripts, no `.session/` folder. History lives in git, PRs and ADRs.
- Keep it a short index plus sections. Narrative and rationale move to `docs/`.

## Git workflow and branching

{{git_workflow}}

## Stack

**Stacks:** {{stacks}}

**Org templates:** {{org_templates}}

{{stack_sections}}

## Layout

{{layout}}
