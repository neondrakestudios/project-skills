# Neon Drake Project Skills

Claude Code skills for the Neon Drake context system. Every repo that follows it keeps two things apart:

- `context/` — an Obsidian vault of agent-facing current state, rewritten in place.
- `docs/` — an optional sibling Obsidian vault of human documentation, immutable once accepted.
- `CLAUDE.md` — self-contained policy: the vault table, classification and linking rules, session start, git workflow, and the project's kind and stacks.

It isn't only for code. A repo's *kind* — `software`, `cad` for something designed and built, like furniture, or `writing` for a novel — decides which rules, files and vaults it gets.

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
| `/neondrake:scaffold-project` | Sets a new or existing repo up with the vaults, `CLAUDE.md`, and kind- and stack-specific conventions |

## scaffold-project

```
/neondrake:scaffold-project [kind=NAME] [stacks=a,b|none] [docs=yes|no] [org=OWNER/REPO|PATH|none] [ticket=KEY-123] [generate=yes|no] [series=yes|no] [dry-run]
```

- `kind=` — the project's kind. Defaults to `software` on a repo with files; asked on an empty one. Fixed once scaffolded.
- `stacks=` — stack overlays to apply. Adds to any already recorded in `CLAUDE.md`; never removes.
- `docs=no` — skip the `docs/` vault; decisions then live as rows in `context/DECISIONS.md`. The kind sets the default. Fixed once scaffolded.
- `org=` — an org override source, a GitHub repo or local path. Recorded in `CLAUDE.md` so re-runs and teammates use the same one.
- `ticket=` — the ticket for the scaffold's work branch, when the branch pattern needs one.
- `generate=no` — don't offer the stack's own generator (`dotnet new`, `ng new`, …).
- `series=yes` — with `storyline`, the books form a StoryLine series. Asked when not given; detected from an existing `series.json`.
- `dry-run` — report what would happen; ask nothing, run nothing, write nothing.

It also sets up git to match the workflow, asking before each change and never pushing. The kind sets the default workflow: `software` uses work branches and pull requests; `cad` and `writing` commit straight to `main`. A new repo gets an empty `.gitignore` commit on `main`, and an integration branch such as `dev` with the project `.gitignore`: the stacks' [github/gitignore](https://github.com/github/gitignore) templates plus JetBrains rules that keep shared IDE settings. Repo-only identity is set if none exists. The scaffold itself is written on a work branch off the integration branch — pass `ticket=KEY-123` when the branch pattern needs one — and offered as one commit for a pull request.

### Kinds

| Kind | For | Adds | Defaults |
|---|---|---|---|
| `software` | Applications, services, libraries | BDD testing conventions | `docs/` vault; branches and pull requests |
| `cad` | Furniture, woodworking, fabrication | Units, load and safety rules in `CLAUDE.md`; `context/MATERIALS.md` bill of materials; `docs/drawings/` | Asks about `docs/`; commits directly to `main` |
| `writing` | Novels, stories, long-form writing | A project-named Obsidian vault for the story and all its notes; prose rules — the agent drafts only when asked, marking what it wrote; a style-sheet section in `CONVENTIONS.md` | No `docs/`; commits directly to `main` |

Stacks belong to a kind, which only decides what the stack question offers: `freecad` is a `cad` stack, and `storyline` — the [StoryLine](https://github.com/PixeroJan/obsidian-storyline) Obsidian plugin — a `writing` one. For writing, the skill asks for the vault-folder name, suggesting the repository name; StoryLine keeps research, corkboard notes, characters and locations in that vault beside the scenes, so the reference material is in view while you write. The skill enables the plugin in the vault but doesn't install it: Obsidian does, from Community plugins.

For a series, StoryLine shares one Codex across the books. The generated `CLAUDE.md` then keeps cross-book items — plot threads, mysteries, foreshadowing — as entries in custom categories of that shared Codex, which scenes in any book link to. The series itself is still created in StoryLine, with **Create Series from Current Project**.

Re-running is safe: existing files are never overwritten. Missing files are added, and differences from the current templates are reported for you to resolve.

### Template layers

Three layers, each a directory shaped like `skills/scaffold-project/templates/` — base files, `kinds/` and `stacks/` — least specific first:

| Layer | Location |
|---|---|
| Bundle | `skills/scaffold-project/templates/` |
| Org override | a repo or path given by `org=` |
| Project override | `.claude/context-templates/` in the target repo |

Resolution happens in two passes:

1. **File-level replacement.** For every path — a base file or a single stack fragment — the most specific layer holding it wins outright.
2. **Additive overlays.** The kind's winning fragments (`kinds/NAME/…`), then each chosen stack's (`stacks/NAME/…`), are appended to the winning base files, composing across stacks; a fragment with no base counterpart becomes a new file.

So an override can replace a base file without dropping any kind or stack sections, replace one fragment, or add a whole kind or stack. It holds only the files it changes; it is not a fork. Two extra files are recognized at an override's root:

- `CLAUDE.append.md` — appended to the generated `CLAUDE.md`.
- `git-workflow.md` — a finished git workflow section, used instead of the interview.

### Adding a kind

Add a directory under `templates/kinds/`; the listing is the list.

```
kinds/NAME/
├── kind.md                  metadata: title, docs (yes|no|ask), git (pull-requests|direct), vaults, slots for the base files
├── gitignore-fragment       optional ignore lines, e.g. for the kind's vaults
├── CLAUDE.md                ## section, loaded every session, for rules that hold for the whole kind
├── context/…                sections appended to base context files, or new context files
├── docs/…                   sections appended to docs/index.md, or extra docs folders
└── VAULT/…                  a vault the kind declares, e.g. writing's project-named vault `.obsidian/`
```

Base templates stay kind-neutral. Text that depends on the docs vault or on pull requests sits in `{{#docs}}…{{/docs}}` or `{{#pull_requests}}…{{/pull_requests}}` sections, with `{{^flag}}` for the opposite. A stack can declare its own flags in `stack.md`'s `flags` field, as `storyline` does with `series`; its notes say how each is decided, and a `NAME=yes|no` argument sets it.

### Adding a stack

Add a directory under `templates/stacks/`. Nothing else changes; the directory listing is the list.

```
stacks/NAME/
├── stack.md                 metadata: title, kind, requires, detect (globs, optionally with contains), unless, generators, flags
├── gitignore-fragment       optional ignore lines, when github/gitignore has no template
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
