# {{project_name}}

{{summary}}

## Where things live

{{vault_intro}}

| Root | Holds | Lifecycle |
|---|---|---|
| `context/` | Agent-facing current state, loaded every session | Rewritten in place for its whole life |
{{#docs}}
| `docs/` | {{docs_holds}} | Mutable while draft; immutable once published or accepted |
{{/docs}}
{{kind_roots}}

| File | Read it |
|---|---|
| `context/PROJECT_STATE.md` | At every session start |
| `context/CONVENTIONS.md` | {{conventions_when}} |
| `context/DECISIONS.md` | Before changing anything cross-cutting |
| `context/GLOSSARY.md` | When a term is unfamiliar |
{{kind_files}}
{{#docs}}
| `docs/index.md` | When looking for documentation |
| `docs/architecture/decisions/` | When you need why, not what |
{{/docs}}

Retrieval is by name: this table, then grep.

## Session start

1. Read `context/PROJECT_STATE.md`.
2. Verify it against live state — {{#pull_requests}}`gh pr list --state open --base {{default_branch}}`, CI status, {{/pull_requests}}recent `git log`. The file reflects only its last manual edit. Where they disagree, live state wins; correct the file in your next {{change_unit}}.

## Classification rule

{{#docs}}
- **Context files** (`context/`) are rewritten in place for their whole life. They never accumulate.
- **Documentation files** (`docs/`) are mutable while in draft and immutable once published or accepted. A changed decision is a new ADR that supersedes the old one; the old ADR's status becomes `Superseded by ADR-NNNN` and nothing else in it changes.
- A draft is edited freely. The editable phase ends for documentation and never ends for context.
{{/docs}}
{{^docs}}
- **Context files** (`context/`) are rewritten in place for their whole life. They never accumulate.
- A decision is one row in `context/DECISIONS.md` with its reason. A changed decision replaces its row; git keeps the history.
{{/docs}}

## Linking rule

{{#docs}}
Wikilinks are vault-scoped and cannot cross between `context/` and `docs/`.

- **context → docs:** relative Markdown links only, e.g. `[ADR-0012](../docs/architecture/decisions/ADR-0012-example.md)`. Never `[[wikilinks]]`.
- **docs → context:** never. Live status is not documentation's job.
- Wikilinks, `.canvas` files and maps of content live only in {{wikilink_vaults}}.
- Keep `context/` files frontmatter-light; every line is loaded every session.
{{/docs}}
{{^docs}}
- **context/:** relative Markdown links only. Never `[[wikilinks]]`, `.canvas` files or maps of content.
- Keep `context/` files frontmatter-light; every line is loaded every session.
{{/docs}}

## Keeping PROJECT_STATE current

{{#pull_requests}}
- **Same-PR rule:** update `context/PROJECT_STATE.md` in the same PR as the change that alters state, worded as it will read once merged. No separate "refresh state" PRs.
{{/pull_requests}}
{{^pull_requests}}
- **Same-commit rule:** update `context/PROJECT_STATE.md` in the same commit as the change that alters state. No separate "refresh state" commits.
{{/pull_requests}}
- Edit in place. It is never a session log: no transcripts, no `.session/` folder. History lives in {{history}}.
- Keep it a short index plus sections. {{#docs}}Narrative and rationale move to `docs/`.{{/docs}}{{^docs}}Rationale goes in `context/DECISIONS.md`.{{/docs}}

{{kind_section}}

## Git workflow and branching

{{git_workflow}}

## Stack

**Kind:** {{kind}}

**Stacks:** {{stacks}}

**Docs vault:** {{docs_vault}}

**Org templates:** {{org_templates}}

{{stack_sections}}

## Layout

{{layout}}
