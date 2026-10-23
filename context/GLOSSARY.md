# Glossary

| Term | Meaning |
|---|---|
| Bundle | The templates shipped in `skills/scaffold-project/templates/`; the least specific layer |
| Layer | One source of templates, shaped like `templates/`: bundle, org override or project override |
| Kind | What sort of project a repo is — `software`, `cad`, `writing` — recorded as `**Kind:**`; one per repo, never changed |
| Kind overlay | `templates/kinds/NAME/` in any layer; applied before the stacks, with `kind.md` setting defaults, extra vaults and kind-wide slots |
| Flag | `docs` or `pull_requests`; selects `{{#flag}}…{{/flag}}` and `{{^flag}}…{{/flag}}` conditional sections in templates |
| Stack overlay | `templates/stacks/NAME/` in any layer; its files are appended to base files or added as new ones |
| Fragment | One file inside a kind or stack overlay |
| Org override | A repo or path given by `org=`, holding only its differences: replaced files, added stacks, and optionally `CLAUDE.append.md` and `git-workflow.md` |
| Project override | `.claude/context-templates/` in the target repo |
| Slot | A `{{name}}` placeholder the skill fills from evidence, or leaves as `TODO:` |
| Provenance | The list of layers that contributed to one output file, shown in the report |
| Scaffolded | A repo whose `CLAUDE.md` has a `**Stacks:**` line; re-runs read state from it |
| Generator | An ecosystem's own scaffolding command recorded in `stack.md`, e.g. `dotnet new` |
