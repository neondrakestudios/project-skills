---
name: scaffold-project
description: "Scaffold a new or existing repo to follow the Neon Drake context system: two-vault context and documentation, CLAUDE.md, and stack-specific conventions. Offers to run the ecosystem's own generator; does not generate project files itself."
argument-hint: "[stacks=a,b|none] [org=OWNER/REPO|PATH|none] [generate=yes|no] [dry-run]"
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/scripts/dump-templates.sh *)
---

# Scaffold project

Arguments: $ARGUMENTS

Bundled templates: `${CLAUDE_SKILL_DIR}/templates/`

The stacks on offer are the subdirectories of `stacks/` in the resolved layers (step 2) — list them from disk.

Everything this skill needs from outside the target repo — its templates, `git-workflow.md`, the plugin manifest and an org override checkout — is read through one pre-approved command, so no permission prompt appears. Run it once, with every directory you need, and work from its output:

`${CLAUDE_SKILL_DIR}/scripts/dump-templates.sh ${CLAUDE_SKILL_DIR} ${CLAUDE_PLUGIN_ROOT}/.claude-plugin [ORG_CHECKOUT]`

Each file appears under a `=== FILE path ===` line within its `=== LAYER dir ===` block. Never use Read, Glob, Grep or other shell commands on these directories. The project layer, `.claude/context-templates/`, is inside the repo; read it normally. Never offer a stack from memory or from this file.

## Invariants

These override anything below that seems to conflict.

- **Never overwrite.** Nothing already in a file is ever changed or removed. An existing file only gains the additions step 7 lists; everything else about it is reported, not resolved.
- **Idempotent.** A second run with the same inputs changes nothing and says so.
- **No project files.** Never write a `.csproj`, `package.json`, solution file, lockfile, CI workflow or any file a stack's own generator produces. The only edits to such files are the additions a stack's notes define (step 7). Offer the generator; if declined, list the command in the report.
- **Self-contained output.** Generated files never reference the home directory, this plugin, or `@` imports. Everything a teammate or CI agent needs is in the repo.
- **No logs.** Never create session logs, transcripts, changelogs or a `.session/` folder.
- **No /init.** Do this survey yourself; do not invoke or imitate the built-in command's output.

## 1. Detect

Work at the git root (`git rev-parse --show-toplevel`), else the current directory. Record:

- Whether `CLAUDE.md`, `context/`, `docs/`, `.gitignore`, `README*` and `.claude/context-templates/` exist.
- **Empty or not.** The repo is *empty* when it has no file outside `.git/`, `.claude/`, `context/`, `docs/`, other dot-directories (`.github/`, `.vscode/`, `.idea/`…), `CLAUDE.md`, `README*`, `LICENSE*`, `.gitignore`, `.gitattributes` and `.editorconfig`.
- **Scaffolded or not.** The repo is *scaffolded* when `CLAUDE.md` contains a `**Stacks:**` line.
- Default branch: `git symbolic-ref --short refs/remotes/origin/HEAD` (strip `origin/`), else the current branch, else `main`.
- `project_name`: the solution or package name, else the repository directory name.

Resolve in this order: the org source, then the available stacks (step 2 lists them across all layers), then the chosen stacks.

**Org override source** — first that applies: `org=` argument; the `**Org templates:**` line in `CLAUDE.md`; otherwise none. `org=none` means none. A GitHub `OWNER/REPO` is fetched with `gh repo clone OWNER/REPO <tmp> -- --depth 1`; a path is used in place. Record the commit SHA for the report. If the fetch fails, stop and report — do not silently fall back to the bundle.

**Stacks:**

- **Scaffolded:** the recorded stacks, plus any `stacks=` names — the argument adds, never removes. Never ask. A stack inferred from code but not recorded goes in the report as a decision; do not add it.
- **Not scaffolded:** the `stacks=` names if given; otherwise the inferred stacks; otherwise ask — on an empty repo, and on a non-empty one where nothing was inferred. When you cannot ask, record `none` and report it.
- `stacks=none` means no stacks and skips inference; it cannot be combined with other names, and on a scaffolded repo it adds nothing.
- **Required stacks.** A chosen stack's `requires` list adds those stacks too — `orleans` brings `dotnet` — and the report says so.
- An unknown stack name stops the run before anything is written.

**Inferring:** for each available stack, match its `stack.md` `detect` entries anywhere in the tree. An entry is a glob, or a `glob` with `contains`, which matches only files whose text contains that string. Search skipping `node_modules/`, `bin/`, `obj/`, `dist/`, `target/`, `.venv/`, `deps/`, `_build/`, `vendor/`. Check a stack's `unless` globs in the directory of each `detect` match: a match is suppressed when that same directory holds an `unless` file, and the stack is inferred if any match survives. So a root with `angular.json` and `tsconfig.json` is `angular` only, while `web/angular.json` plus `api/tsconfig.json` is `angular` and `typescript`. Say which file matched each inferred stack and where, and which `unless` file suppressed a match.

**Asking** (never in a dry run): ask for every stack the project will use — a repo commonly has more than one, such as .NET with Angular. Use one AskUserQuestion call with `multiSelect: true` questions, one option per available stack labelled with its `stack.md` title, sorted by title. A question holds at most four options, so split the stacks across up to four questions headed "Stacks 1/N", "Stacks 2/N" and so on; the answer is the union of every selection. Only past sixteen stacks, ask in plain text listing all of them.

## 2. Resolve templates

Every layer is a directory shaped like `templates/`:

| Layer | Location | Provenance label |
|---|---|---|
| bundle | `${CLAUDE_SKILL_DIR}/templates/` | `bundle` |
| org | root of the org override source | `org:OWNER/REPO@SHA` or `org:PATH` |
| project | `.claude/context-templates/` in the target repo | `project` |

Resolution:

- **Available stacks** are the union of `stacks/*/` directory names across all three layers.
- **File-level replacement.** For every relative path — base files and stack files alike — the most specific layer holding that path wins outright: project over org over bundle. Never merge two versions of one file. An override can therefore replace a base file, replace one stack fragment, or add a whole stack.
- **Stack overlays are additive.** For each chosen stack, in the order listed, each winning file under `stacks/NAME/` targets the same relative path in the output:
  - Files at the overlay's root other than `CLAUDE.md` — `stack.md`, and data files its notes use, like `solution-items.yaml` — are metadata. Never write them.
  - `CLAUDE.md` fills the `{{stack_sections}}` slot of the base `CLAUDE.md`.
  - A path that also exists as a base file is appended to it.
  - Any other path is a new file.
- **CLAUDE.append.md** at the root of the org layer, then the project layer, is appended to the end of the generated `CLAUDE.md`. This is the only fragment-level addition an override may make.
- Track provenance per output path as the list of contributors, e.g. `context/CONVENTIONS.md ← bundle + stacks/dotnet(bundle) + stacks/angular(org)`.

## 3. Dry run

With `dry-run`, stop after this step: ask nothing, run no generator, write nothing. Produce the step 8 report describing what would be created, appended and skipped, plus the questions that would be asked and the generators that would be offered.

## 4. Offer generators

Only on a repo that is empty and not scaffolded. Do this before writing any file: generators refuse non-empty directories and write their own `.gitignore`.

- **Directories.** Every generator command names its target as `DIR`. With one chosen stack, `DIR` is `.`. With several, first ask where each lives, because two generators writing to the root collide: one stack may keep the root (a .NET solution usually does) and the others get a subdirectory such as `web/` for a front end or `api/` for a service. Substitute `DIR`, the `{{…}}` slots and any other uppercase placeholder a stack's notes define (such as `MAIN`, `TEMPLATE`, `ROLE`), asking for each value once — stacks that share a value, like the .NET namespace, share the answer. Run every command from the repo root.
- **Choosing.** Show each stack's commands and ask which to run. Some lists are a sequence (run all), others are alternatives (pick one); the note beside each command says which. A command noted "only when X is also chosen" is dropped when X isn't.
- **Order.** Run a stack's generators after those of every stack it `requires` or its notes say to follow — `dotnet`, then `aspire`, then `orleans`.
- **Prerequisites.** When a stack's `stack.md` names a tool the generators need, check for it first. If it's missing, show the official install command and ask before running it; if declined, skip that stack's generators and report why.
- **Existing files.** If a `README`, `LICENSE` or `.gitignore` already exists (a repo created on GitHub), say so before running: some generators refuse to run over them. Never add `--force`.
- Run the accepted commands exactly as recorded. On failure, report the output and continue. With `generate=no`, or when you cannot ask, skip and list the commands in the report.

## 5. Git workflow

Fills `{{git_workflow}}`. Skip this step on a scaffolded repo — never re-interview on a re-run. Also skip it when `CLAUDE.md` already has a git section: a `##` heading that matches `Git workflow and branching` (see matching in step 7) or contains `git`, `branch`, `branches` or `branching` as a whole word. `## GitHub Actions` is not a git section. That heading counts as the match for the template's git section in step 7, so the template section is not appended beside it.

Otherwise, if a resolved org or project layer has `git-workflow.md` at its root, use it verbatim as the section and record it in provenance. If not, run the interview in `${CLAUDE_SKILL_DIR}/git-workflow.md`: infer first, ask only what evidence leaves open, then write the section as that file describes.

## 6. Survey and fill slots

Slots are `{{name}}`. Fill each from evidence, in this order of preference: the repo, `gh repo view --json name,description`, the stack overlay. Never invent prose to fill a slot. A slot with no evidence becomes `TODO: <what is needed>` and goes in the report. Never invent stand-in syntax such as `<exec>`: a line that depends on an unfilled slot becomes a single `TODO:` line.

- `project_name`: from step 1.
- `summary`: first paragraph of the README, else the GitHub description, else TODO.
- `default_branch`: the branch PRs target (also used by the PR count in step 7) — the integration branch from step 5 (or from an existing git section) when there is one, else the default branch from step 1.
- `stacks`: comma-separated stack directory names, or `none`.
- `org_templates`: the org source as given, or `none`.
- `git_workflow`: from step 5.
- `stack_sections`: each stack's `CLAUDE.md` fragment. Where the repo exists, correct its commands and layout against what is actually there — the real startup project, test projects, scripts. When a stack lives in a subdirectory, start its section with a `- Location: \`DIR/\`` line and write its commands as run from there.
- `layout`: the top two levels of the tree, excluding `context/` and `docs/`, one line each. On an empty repo, use the stacks' expected-layout lines and label them "expected".
- Stack fragment slots such as `{{dotnet_startup_project}}`: from the repo, else TODO. When the stack's `stack.md` body says how to fill its slots or which lines to keep, follow it.

For a new `CONVENTIONS.md` on a repo with code, replace a heading's `<!-- -->` guidance line with conventions you can point to evidence for (`.editorconfig`, analyzer and lint config, `Directory.Build.props`, `tsconfig.json`, consistent patterns in the code). Keep the guidance line where there is no evidence. Where a stack fragment states a concrete convention that the code contradicts — the fragment says NUnit, the test projects use xUnit — write what the code does and list the mismatch under "Needs your decision".

## 7. Write

Create `context/` and `docs/` at the root, never one inside the other, with each `.obsidian/` from the templates. Then, for every resolved output path:

**Heading matching**, used throughout: `##` headings match case-insensitively, and match when either one starts with the other — `Git Workflow and Branching` matches `Git workflow and branching`, `Stack and tooling` matches `Stack`. Wherever this step says "the X section", it means the section whose heading matched the template's X heading.

- **Missing file:** create it. Put `.gitkeep` only in directories that would otherwise be empty.
- **Existing file:** leave it untouched and list it as skipped. The only exceptions:
  1. `.gitignore` — collect the lines of the resolved `gitignore-fragment` not already present verbatim. If any, append them as one block at the end of the file, preceded by the fragment's header comment only when that comment isn't already in the file. Create `.gitignore` if missing.
  2. A stack being added (chosen now, absent from the recorded `**Stacks:**` line) — append its fragment to each existing target file whose text does not already contain the fragment's first heading, insert its `CLAUDE.md` fragment at the end of the section holding the `**Stacks:**` line, and add the stack to that line.
  3. An existing `CLAUDE.md` that is not scaffolded, as described next.
  4. Additions a chosen stack's `stack.md` notes define for a file the stack's tools own, such as .NET solution items. Apply them on every run, only ever adding entries, and report what was added.
  5. The one conversion a stack's notes define for project files its generators created in this same run, such as moving .NET package versions into `Directory.Packages.props`. Never apply it to files that existed before the run.

**Existing CLAUDE.md never scaffolded** (no `**Stacks:**` line): keep every line of it. Append each `##` section of the generated `CLAUDE.md` whose heading it lacks. For each heading it already has, keep its version and report the section as a conflict with a one-line description of the difference. If it already has a Stack section, insert the `**Stacks:**` and `**Org templates:**` lines at the top of that section, and append each chosen stack's `CLAUDE.md` fragment at its end unless the section already contains that fragment's first heading. Either way the file must end up with a `**Stacks:**` line — without it, the next run cannot tell the repo was scaffolded.

**Existing CLAUDE.md already scaffolded:** do not add sections, even ones the template has and the file lacks — they may have been removed deliberately. Report each such missing section, and each section without slots — the policy sections — whose text differs from the current template, so template changes surface without being forced. Sections built from slots are expected to differ; don't report them.

**PROJECT_STATE.md**, only when creating it: seed it with facts true today — the scaffold date as an absolute date, the stacks, which generators ran, the default branch, open PR count (`gh pr list --state open --base {{default_branch}}`) when there is a GitHub remote, and whether CI config exists. A section with nothing true yet says "None yet." Never write aspirational or placeholder prose.

Before finishing, grep every file you wrote for `~/`, `$HOME`, `/home/`, `/Users/`, `@~`, and `[[` under `context/`. Fix any hit in output you created; report hits in files you did not create.

## 8. Report

Print, in this order, omitting empty sections:

1. **Stacks** — each with how it was determined (recorded, argument, inferred from `<file>`, asked).
2. **Git workflow** — each value and how it was determined (existing section, override file, inferred from `<evidence>`, asked).
3. **Created** — new paths. A new file is listed here only, however many layers contributed to it; its contributors are in Provenance.
4. **Appended** — existing files that received additions, with what was added. Never a file this run created.
5. **Skipped** — existing paths left untouched.
6. **Needs your decision** — conflicts, missing or differing sections, TODO slots, stacks inferred but not recorded, generators not run and their commands.
7. **Provenance** — a table of every output path and its contributors, with each layer's location: bundle path and plugin version (from `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`), org source and SHA, project path.

Then stop. Do not commit.
