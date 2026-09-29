# Conventions

## Templates
- A template is headings plus one `<!-- -->` line saying what belongs under each. Write real rules only where they hold for every repo that gets the file.
- Slots are `{{name}}`, filled by the skill from evidence. Every slot a template uses must be listed in step 6 of `SKILL.md`, or be a stack slot prefixed with its stack name, like `{{dotnet_startup_project}}`.
- `context/` templates stay frontmatter-light; `docs/` templates may carry frontmatter.
- The stack list is the directory listing of `templates/stacks/`. Never write a list of stacks anywhere else.
- An overlay never contains a project file — no `.csproj`, `package.json`, solution, lockfile or CI workflow. Record the generator command in `stack.md` instead.

## Skills
- `SKILL.md` frontmatter follows the current Claude Code skills reference; check it before adding a field. The `scaffold-project` description is fixed text — never paraphrase it. It is quoted because it contains `: `.
- The plugin sits outside the target repo, so reading it normally triggers a permission prompt. Read plugin files only through `scripts/dump-templates.sh`, which `allowed-tools` pre-approves as a Bash rule. Read/Glob/Grep rules can't be pre-approved this way: `${CLAUDE_SKILL_DIR}` is substituted only in Bash rules. Don't use `!` shell injection on plugin paths either: the command is blocked and the whole skill aborts without a message.
- Scope ends at a repo that is set up and builds. Generated projects stay in their template defaults: the skill never writes, edits or deletes application code, such as template placeholder files or host wiring like `UseOrleans`.
- Keep `SKILL.md` to the procedure. A long sub-procedure goes in a sibling file the skill reads on demand, like `git-workflow.md`.
- Generated output never references the home directory, this plugin, or `@` imports.

## Naming
- Skill directories and stack directories are lowercase kebab-case; a stack's directory name is what `**Stacks:**` records.
- Branches: see the git workflow in `CLAUDE.md`.

## Testing
Prefer scenario tests: run the skill against scratch repos outside this one and check the resulting files and report. Cover an empty repo, an existing repo with a `CLAUDE.md`, and a re-run over a scaffolded repo. A change to write or re-run behavior needs a re-run scenario that shows a second run changes nothing.

## Commits and pull requests
- One change per PR, from a work branch into `main`.
- `claude plugin validate .` and `claude plugin validate skills` pass before a PR.
- Bump `version` in `plugin.json` when a change alters generated output.

## Documentation
A change to a settled design choice is a new ADR superseding the old one, plus the matching row in `context/DECISIONS.md`. `README.md` is the user-facing guide; keep its usage and layer tables in step with `SKILL.md`.
