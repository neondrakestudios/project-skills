# Neon Drake Project Skills

Claude Code skills for the Neon Drake context system. Every repo that follows it keeps two things apart:

- `context/` — an Obsidian vault of agent-facing current state, rewritten in place.
- `docs/` — a sibling Obsidian vault of human documentation, immutable once accepted.
- `CLAUDE.md` — self-contained policy: the two-root table, classification and linking rules, session start, git workflow, and the chosen stacks.

Output never depends on this plugin. The plugin is the generator; the committed files are the artifact.

## Install

This repo is its own marketplace (`neondrake`), so install once from a local clone:

```
claude plugin marketplace add /path/to/project-skills
claude plugin install project-skills@neondrake
```

The plugin loads in place from the clone: edits take effect at the next session or `/reload-plugins`, without a version bump.

## Skills

| Command | Does |
|---|---|
| `/neondrake:scaffold-project` | Sets a new or existing repo up with the two vaults, `CLAUDE.md` and stack-specific conventions |

## scaffold-project

```
/neondrake:scaffold-project [stacks=a,b|none] [org=OWNER/REPO|PATH|none] [ticket=KEY-123] [generate=yes|no] [dry-run]
```

- `stacks=` — stack overlays to apply. Adds to any already recorded in `CLAUDE.md`; never removes.
- `org=` — an org override source, a GitHub repo or local path. Recorded in `CLAUDE.md` so re-runs and teammates use the same one.
- `ticket=` — the ticket for the scaffold's work branch, when the branch pattern needs one.
- `generate=no` — don't offer the stack's own generator (`dotnet new`, `ng new`, …).
- `dry-run` — report what would happen; ask nothing, run nothing, write nothing.

It also sets up git to match the workflow, asking before each change and never pushing. A new repo gets an empty `.gitignore` commit on `main`, and an integration branch such as `dev` with the project `.gitignore`: the stacks' [github/gitignore](https://github.com/github/gitignore) templates plus JetBrains rules that keep shared IDE settings. Repo-only identity is set if none exists. The scaffold itself is written on a work branch off the integration branch — pass `ticket=KEY-123` when the branch pattern needs one — and offered as one commit for a pull request.

Re-running is safe: existing files are never overwritten. Missing files are added, and differences from the current templates are reported for you to resolve.

### Template layers

Three layers, each a directory shaped like `skills/scaffold-project/templates/`, least specific first:

| Layer | Location |
|---|---|
| Bundle | `skills/scaffold-project/templates/` |
| Org override | a repo or path given by `org=` |
| Project override | `.claude/context-templates/` in the target repo |

Resolution happens in two passes:

1. **File-level replacement.** For every path — a base file or a single stack fragment — the most specific layer holding it wins outright.
2. **Additive stacks.** Each chosen stack's winning fragments (`stacks/NAME/…`) are appended to the winning base files, composing across stacks; a fragment with no base counterpart becomes a new file.

So an override can replace a base file without dropping any stack's sections, replace one stack fragment, or add a whole stack. It holds only the files it changes; it is not a fork. Two extra files are recognized at an override's root:

- `CLAUDE.append.md` — appended to the generated `CLAUDE.md`.
- `git-workflow.md` — a finished git workflow section, used instead of the interview.

### Adding a stack

Add a directory under `templates/stacks/`. Nothing else changes; the directory listing is the list.

```
stacks/NAME/
├── stack.md                 metadata: title, requires, detect (globs, optionally with contains), unless, generators
├── *.yaml                   optional data the stack's notes use, e.g. dotnet's solution-items.yaml
├── CLAUDE.md                ### section for build/test/run and expected layout
├── context/CONVENTIONS.md   ## section appended to CONVENTIONS.md
└── docs/…                   extra docs folders for this stack
```

`generators` records the ecosystem's own scaffolding commands. The skill only hand-generates a project file when no official generator is available. Container support is the case today: asked once per scaffold, each stack uses its official container generator where one exists (Phoenix) and otherwise its bundled `Dockerfile.template` — Alpine runtime, non-root, `BUILD_CONFIGURATION` and `APP_VERSION` build arguments — with one root `compose.yaml` and `.dockerignore` assembled from the stacks' `compose.template.yaml` and `dockerignore.template`. Edits to generated files are additive: a stack's notes may define entries to add to a file its tools own, as the .NET stack does for solution folders.

## Local development

```
claude --plugin-dir /path/to/project-skills
claude plugin validate /path/to/project-skills
```

Run `/reload-plugins` in a session to pick up edits. Add a skill as `skills/NAME/SKILL.md`; it is invoked as `/neondrake:NAME`.
