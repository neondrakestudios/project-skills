---
status: Accepted
date: 2026-10-02
supersedes: ADR-0004
superseded-by:
---

# ADR-0007: Hand-generate project files only when no official generator is available

## Context
ADR-0004 said the skill never writes a project file itself and always offers the ecosystem's generator. Container files break that assumption: Rider and Visual Studio generate a `Dockerfile` and `compose.yaml` for a new .NET project, but `dotnet new` doesn't, and `docker init` is interactive only and ships with Docker Desktop, so a skill can't drive it.

## Decision
Offer the ecosystem's generator whenever an official one is available, and only hand-generate a project file when none is — none exists, or none can run without an interactive terminal. A hand-generated file comes from a template the stack bundles, is written only after the user says yes, and never replaces an existing file. Edits to generator-produced files stay limited to what a stack's notes define: adding solution items to the `.slnx`, and moving package versions into `Directory.Packages.props` for projects created in the same run, because `dotnet new` templates write versions into each project file and no command moves them.

The hand-generated case today is container support. On a first scaffold the skill asks "Add container support?" once, then each stack offers its official container generator where one exists (Phoenix's `mix phx.gen.release --docker`) or renders its bundled `Dockerfile` template for each runnable app, and the skill assembles one root `compose.yaml` and `.dockerignore` from the stacks' parts. Every rendered container has the same shape: a build stage, a minimal Alpine runtime stage running as a non-root user, an OCI version label, and `BUILD_CONFIGURATION` and `APP_VERSION` build arguments — so a pipeline sets both the same way for every stack. Images use fully qualified names so they resolve under both Docker and podman.

For .NET: The Dockerfile builds on the full SDK image and runs on minimal Alpine `aspnet` or `runtime` images — the `-extra` variant, with ICU and time-zone data, when the project uses Entity Framework; chiseled-extra before .NET 10, which has no Alpine `-extra` images. It publishes ReadyToRun for `linux-musl` on the target architecture, takes `BUILD_CONFIGURATION` and `APP_VERSION` build arguments, and runs as a non-root user.

## Consequences
Bundled templates must be kept current by hand as image tags and practice change. Verified with podman, each serving or running as a non-root user with the version label set:

- .NET: an Alpine API, and a worker on both `runtime:10.0-alpine-extra` and `runtime:10.0-noble-chiseled-extra`.
- Node (npm), TypeScript (npm + tsc) and TypeScript on Bun.
- Angular on unprivileged nginx, including a deep-link fallback.
- Rust: a 9 MB static musl binary on Alpine.
- Elixir: a 39 MB Mix release on Alpine.

## Alternatives considered
`docker init` — interactive and Docker Desktop only. SDK container publishing (`dotnet publish -t:PublishContainer`) — needs no Dockerfile, but gives no `compose.yaml` and moves build settings into project properties. Leaving container files to the IDE — scaffolded repos would differ by whoever created them.
