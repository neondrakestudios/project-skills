---
status: Accepted
date: 2026-09-28
supersedes:
superseded-by:
---

# ADR-0004: Offer ecosystem generators; never write project files

## Context
Official scaffolders (`dotnet new`, `ng new`, `cargo init`, `uv init`) stay current; a Markdown copy of their output is stale within weeks.

## Decision
A stack's `stack.md` records its generator commands. On a repo with no source code, the skill offers them before writing any file, because generators refuse non-empty directories and write their own `.gitignore`. The skill never writes a project file, lockfile, solution or CI workflow itself. The one exception is additive and defined by a stack: the .NET stack adds solution folders of repo files to the `.slnx`, because `dotnet sln` can add projects but not loose files. It only adds entries, in the form `dotnet sln` itself writes. The .NET stack also enables Central Package Management after its generators run: `dotnet new` templates write package versions into each project file and no CLI command moves them, so the skill moves them into `Directory.Packages.props` once, only for projects created in that same run.

## Consequences
The survey step sees real generated code. Declined generators are listed in the report with their commands.

## Alternatives considered
Offering generators after scaffolding, as first specified — `dotnet new gitignore` then fails on the existing `.gitignore`.
