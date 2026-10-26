# Project state

Rewritten in place; never appended to. Keep each section under ~10 lines — anything longer is narrative and belongs in `docs/`.

| Section | Holds |
|---|---|
| Focus | What the project is working toward right now |
| In flight | Open PRs and active branches, one line each |
| Blocked | What is stuck and on whom |
| Known issues | Live defects and gaps not yet fixed |
| Next | The few things queued after the current focus |

## Focus
Release 0.4.0 of the `scaffold-project` skill (installable as `project-skills@neondrake`): project kinds (`software`, `cad`, `writing`) beneath the stacks, an optional `docs/` vault, a `manuscript/` vault for writing, a direct-commit git workflow, the `freecad` and `storyline` stacks, and StoryLine series with cross-book items in a shared Codex — on top of 0.2.0's repository setup, generators-first rule and container support.

## In flight
None.

## Blocked
None yet.

## Known issues
- Verified interactively: .NET with Angular in `web/`, and .NET with Orleans, including the generator offer, Central Package Management and solution items. The split stack question beyond four stacks is untested.
- Neither vault's Obsidian settings have been confirmed by opening them in Obsidian.
- If generators are declined, running `dotnet new gitignore` later needs `--force`, which drops the Obsidian lines; a re-run adds them back.
- A generated Session start checks PRs against the integration branch when there is one; untested.
- Repository and work-branch setup has only been dry-run; its prompts need an interactive run.
- Container templates for every stack are verified by hand with podman, not yet through the skill; Phoenix's official container generator is untested.
- The `cad` and `writing` kinds, the direct-commit workflow and a run without `docs/` have only been dry-run. StoryLine's folder layout and frontmatter are taken from its README and HELP (v1.11.0), not from a live vault. The `series` flag and the shared-Codex conventions are untested in a live series.
- On a repo that already has commits, the stacks' `github/gitignore` templates are never added — only IDE and Obsidian lines are appended — so e.g. `node_modules/` stays unignored.
- Only `dotnet` has a full set of written conventions; `javascript` and `typescript` have only the Fastify rule, and the rest are placeholders.
- The `aspire` and `dapr` generator sequences have not run through the skill. Run by hand, the Aspire commands succeed, but the AppHost build needs the Aspire CLI, which isn't installed here.

## Next
- Run the three scenarios interactively.
- Write real conventions for the non-.NET overlays.
