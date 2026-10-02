---
title: .NET
detect:
  - "*.sln"
  - "*.slnx"
  - "*.csproj"
  - "*.fsproj"
  - global.json
  - Directory.Build.props
gitignore:
  - Dotnet.gitignore
generators:
  - "dotnet new sln -n {{dotnet_namespace}} -o DIR   (sequence: run all, in order)"
  - dotnet new editorconfig -o DIR
  - "dotnet new TEMPLATE -o DIR/src/MAIN   (ask for TEMPLATE and ROLE; `dotnet new list` shows templates)"
  - dotnet new nunit -o DIR/tests/MAIN.Tests
  - dotnet add DIR/tests/MAIN.Tests reference DIR/src/MAIN
  - dotnet add DIR/tests/MAIN.Tests package Reqnroll.NUnit
  - dotnet add DIR/tests/MAIN.Tests package AwesomeAssertions
  - dotnet add DIR/tests/MAIN.Tests package NSubstitute
  - dotnet sln DIR add DIR/src/MAIN DIR/tests/MAIN.Tests
---
C# / F# projects built with the dotnet CLI.

Every project is named `{{dotnet_namespace}}.ROLE`, e.g. `NeonDrake.App.Api`, `NeonDrake.App.Web`. `MAIN` is the main project, `{{dotnet_namespace}}.ROLE`.

- `dotnet_namespace`: on a repo with projects, the prefix they share. On an empty repo, ask once, offering the PascalCase form of `project_name` as the default (`sp-live` → `SpLive`); every .NET-based stack uses the same answer.
- `ROLE`: ask with the template, suggesting one from it — `webapi` → `Api`, `blazor` → `Web`, `worker` → `Worker`, `console` → `Cli`, `classlib` → `Core`.

The test project follows the testing conventions: NUnit, with Reqnroll `.feature` specs running on it, AwesomeAssertions and NSubstitute. Projects go into the solution with `dotnet sln`, never by editing the solution file.

**Central Package Management.** Package versions live in `Directory.Packages.props`, not in project files. `dotnet new` templates write versions into each `.csproj`, and `dotnet add package` fails once CPM is on while any project still has one — so enable it last, once, after every .NET-based stack's generators have run:

1. `dotnet new packagesprops -o DIR`
2. In each project file created this run, move every `Version` attribute of a `PackageReference` into a `<PackageVersion Include="…" Version="…" />` entry in `Directory.Packages.props`, sorted by name ignoring case. Change nothing else on the element; the move doesn't alter any version. If two projects pin different versions of one package, keep the higher and report it.
3. `dotnet restore DIR` must succeed; if it doesn't, report the error.

From then on, `dotnet add package` writes versions to `Directory.Packages.props` itself. On a repo whose projects existed before this run, don't convert: if it has no `Directory.Packages.props`, list enabling CPM under "Needs your decision".

**Container support** (see step 6 of the skill). No official generator the skill can run creates container files — `dotnet new` has no template, and `docker init` is interactive and ships only with Docker Desktop — so this stack renders its own. Ask which projects get a Dockerfile: suggest every runnable host (web and worker projects), never libraries, tests, the AppHost or ServiceDefaults. `BUILD_CONFIGURATION` defaults to `Release`.

- `Dockerfile` in each chosen project's folder, built from the repo root:
  - `dotnet_version`: from the project's target framework (`net10.0` → `10.0`). The build stage always uses the full SDK image.
  - `container_runtime_image`: `aspnet` for web projects, `runtime` for workers, on the minimal Alpine tag (`aspnet:10.0-alpine`). If the project uses Entity Framework — it, or a project it references, has a `Microsoft.EntityFrameworkCore` package; on a new project, ask — it needs ICU and time-zone data, which plain Alpine leaves out (it runs in globalization-invariant mode): use the `-extra` tag (`aspnet:10.0-alpine-extra`). Alpine `-extra` images exist from .NET 10; for earlier versions use the chiseled-extra tag (`aspnet:9.0-noble-chiseled-extra`).
  - `container_os`: `linux-musl` for Alpine — the SDK build image is Debian (glibc), so publishing for Alpine's musl C library has to be named explicitly, or packages with native files get their glibc builds. `linux` for chiseled, which is Ubuntu (glibc).
  - `container_user`: `USER $APP_UID` for Alpine; leave it out for chiseled, which already runs as a non-root user.
  - `container_expose`: `EXPOSE 8080` for web projects; leave it out for workers.
  - `container_restore_copies`: one `COPY ["PATH", "DIR/"]` line for each of `Directory.Packages.props`, `Directory.Build.props`, `Directory.Build.targets`, `global.json` and `nuget.config` that exists, then for the project file and every project file it references, directly or through other projects.
  - `container_project_path`, `container_assembly`: the project file's repo-relative path and its assembly name.

  Drop any line left empty by an omitted slot. `BUILD_CONFIGURATION` (default `Release`) and `APP_VERSION` (default `1.0.0`) are build arguments, so a pipeline can set them; `TARGETARCH` comes from the builder, giving multi-architecture builds.
- A `compose.yaml` service per Dockerfile, built from the repo root, named after the project in lowercase with dots as dashes (`neondrake-app-api`). Web services get `    ports:\n      - "HOST:8080"` in `container_ports`; leave it out for workers.

**Solution items.** `dotnet sln` can't add loose files, so on every run — after the generators, and on re-runs — add the files listed in `solution-items.yaml` to the `.slnx` directly, as `<Folder Name="/FOLDER/">` elements holding `<File Path="…" />` entries:

- A file at the repo root goes directly in its folder. A file in a subdirectory goes in a subfolder mirroring that directory — `docs/architecture/decisions/ADR-0001-x.md` → `/Documentation/docs/architecture/decisions/`.
- Declare every intermediate folder and keep folders sorted by name, ignoring case (`/Build/`, `/git/`, `/Solution Config/`, `/src/`), the way `dotnet sln` writes them, so a later `dotnet sln add` produces no diff.
- Skip `.gitkeep`, `.obsidian/`, `bin/` and `obj/`.
- Only add. Never remove, move or reorder an existing entry; list entries whose file no longer exists under "Needs your decision".
- For a classic `.sln`, add nothing: report it and suggest `dotnet sln migrate`, which converts it to `.slnx`.

Afterwards, run `dotnet sln list` to confirm the file still parses.
