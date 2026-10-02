# Decisions

Index of cross-cutting choices. One line each; the full reasoning is in the linked ADR.

| ADR | Decision | Status |
|---|---|---|
| [ADR-0001](../docs/architecture/decisions/ADR-0001-two-sibling-vaults.md) | Scaffolded repos get sibling `context/` and `docs/` vaults; links go context → docs only, as relative Markdown | Accepted |
| [ADR-0002](../docs/architecture/decisions/ADR-0002-template-layers.md) | Overrides replace per path across the whole template tree; stack overlays append onto the winning base | Accepted |
| [ADR-0003](../docs/architecture/decisions/ADR-0003-merge-aware-reruns.md) | Never overwrite; state lives in `CLAUDE.md`'s `**Stacks:**` line; re-runs report, not re-add | Accepted |
| [ADR-0004](../docs/architecture/decisions/ADR-0004-ecosystem-generators.md) | Offer the ecosystem's generator before writing anything; never write project files | Superseded by ADR-0007 |
| [ADR-0005](../docs/architecture/decisions/ADR-0005-plugin-naming.md) | Skills run as `/neondrake:…`; installed as `project-skills@neondrake` | Accepted |
| [ADR-0006](../docs/architecture/decisions/ADR-0006-repository-setup.md) | Set up git to match the workflow, then scaffold on a work branch off the integration branch; never push | Accepted |
| [ADR-0007](../docs/architecture/decisions/ADR-0007-generators-first.md) | Hand-generate project files only when no official generator is available; container support across stacks, on Alpine | Accepted |
