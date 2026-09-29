---
title: .NET
detect:
  - "*.sln"
  - "*.slnx"
  - "*.csproj"
  - "*.fsproj"
  - global.json
  - Directory.Build.props
generators:
  - "dotnet new sln -n {{dotnet_namespace}} -o DIR   (sequence: run all, in order)"
  - dotnet new gitignore -o DIR
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

**Solution items.** `dotnet sln` can't add loose files, so on every run — after the generators, and on re-runs — add the files listed in `solution-items.yaml` to the `.slnx` directly, as `<Folder Name="/FOLDER/">` elements holding `<File Path="…" />` entries:

- A file at the repo root goes directly in its folder. A file in a subdirectory goes in a subfolder mirroring that directory — `docs/architecture/decisions/ADR-0001-x.md` → `/Documentation/docs/architecture/decisions/`.
- Declare every intermediate folder and keep folders sorted by name, ignoring case (`/Build/`, `/git/`, `/Solution Config/`, `/src/`), the way `dotnet sln` writes them, so a later `dotnet sln add` produces no diff.
- Skip `.gitkeep`, `.obsidian/`, `bin/` and `obj/`.
- Only add. Never remove, move or reorder an existing entry; list entries whose file no longer exists under "Needs your decision".
- For a classic `.sln`, add nothing: report it and suggest `dotnet sln migrate`, which converts it to `.slnx`.

Afterwards, run `dotnet sln list` to confirm the file still parses.
