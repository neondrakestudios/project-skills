# Neon Drake Project Skills

A Claude Code plugin (`neondrake`, installed as `project-skills@neondrake`) of skills for the Neon Drake context system. Its first skill, `/neondrake:scaffold-project`, scaffolds the two-vault layout and a self-contained `CLAUDE.md` into other repos. This repo is also its own marketplace.

## Where things live

This repo keeps two Obsidian vaults as siblings at the root. They are never nested.

| Root | Holds | Lifecycle |
|---|---|---|
| `context/` | Agent-facing current state, loaded every session | Rewritten in place for its whole life |
| `docs/` | Decision records | Mutable while draft; immutable once accepted |

| File | Read it |
|---|---|
| `context/PROJECT_STATE.md` | At every session start |
| `context/CONVENTIONS.md` | Before editing a skill or template |
| `context/DECISIONS.md` | Before changing anything cross-cutting |
| `context/GLOSSARY.md` | When a term is unfamiliar |
| `docs/architecture/decisions/` | When you need why, not what |
| `README.md` | For install and usage, as users see it |

Retrieval is by name: this table, then grep.

Don't confuse the root vaults with `skills/scaffold-project/templates/context/` and `templates/docs/`. Those are the templates the skill writes into other repos, not this repo's own state.

## Session start

1. Read `context/PROJECT_STATE.md`.
2. Verify it against live state — `gh pr list --state open --base main`, recent `git log`. The file reflects only its last manual edit. Where they disagree, live state wins; correct the file in your next PR.

## Classification rule

- **Context files** (`context/`) are rewritten in place for their whole life. They never accumulate.
- **Documentation files** (`docs/`) are mutable while in draft and immutable once accepted. A changed decision is a new ADR that supersedes the old one; the old ADR's status becomes `Superseded by ADR-NNNN` and nothing else in it changes.
- A draft is edited freely. The editable phase ends for documentation and never ends for context.

## Linking rule

Wikilinks are vault-scoped and cannot cross between `context/` and `docs/`.

- **context → docs:** relative Markdown links only, e.g. `[ADR-0001](../docs/architecture/decisions/ADR-0001-two-sibling-vaults.md)`. Never `[[wikilinks]]`.
- **docs → context:** never. Live status is not documentation's job.
- Wikilinks, `.canvas` files and maps of content live only in `docs/`.
- Keep `context/` files frontmatter-light; every line is loaded every session.

## Keeping PROJECT_STATE current

- **Same-PR rule:** update `context/PROJECT_STATE.md` in the same PR as the change that alters state, worded as it will read once merged. No separate "refresh state" PRs.
- Edit in place. It is never a session log: no transcripts, no `.session/` folder. History lives in git, PRs and ADRs.
- Keep it a short index plus sections. Narrative and rationale move to `docs/`.

## Git workflow and branching

`main` is the base for new work and the target of every PR. Never commit directly to `main`.

No ticket is required. Name branches `feature/<short-description>`, `bugfix/<short-description>` or `improvement/<short-description>` — for example `bugfix/rerun-duplicate-section`.

Before editing, check the current branch. From `main`, create or switch to a work branch for the change. If already on a branch for different work, stop and ask which branch to use.

## Stack

**Stacks:** none

**Org templates:** none

The plugin is Markdown and JSON; there is no build.

- Validate: `claude plugin validate .` (manifest and marketplace) and `claude plugin validate skills` (skill frontmatter). Both must pass before a PR.
- Run locally: `claude --plugin-dir .` from a scratch repo's session, or `/reload-plugins` after edits when installed from this clone.
- Test: run the skill against scratch repos outside this one — empty repo, existing repo with a `CLAUDE.md`, and a re-run over an already-scaffolded repo. For unattended runs use `claude -p "/neondrake:scaffold-project … dry-run" --plugin-dir <this repo>`; pass `--allowedTools` for anything a non-dry run writes or executes.

## Layout

- `.claude-plugin/plugin.json` — plugin manifest; `name` is the `/neondrake:` prefix.
- `.claude-plugin/marketplace.json` — marketplace `neondrake` listing this repo as plugin `project-skills`.
- `skills/scaffold-project/SKILL.md` — the skill's procedure.
- `skills/scaffold-project/git-workflow.md` — the git workflow interview the skill runs.
- `skills/scaffold-project/scripts/dump-templates.sh` — prints plugin files for the skill in one pre-approved call.
- `skills/scaffold-project/templates/` — bundled templates: base `CLAUDE.md`, `context/`, `docs/`, `gitignore-fragment`, and `stacks/NAME/` overlays.
- `context/`, `docs/` — this repo's own vaults.
