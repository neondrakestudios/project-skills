---
title: Aspire
requires:
  - dotnet
detect:
  - glob: "*.csproj"
    contains: Aspire.AppHost.Sdk
  - apphost.cs
generators:
  - "dotnet new install Aspire.ProjectTemplates   (sequence: run all, in order, after the dotnet generators; installs the templates once per machine)"
  - dotnet new aspire-apphost -o DIR/src/{{dotnet_namespace}}.AppHost
  - dotnet new aspire-servicedefaults -o DIR/src/{{dotnet_namespace}}.ServiceDefaults
  - dotnet add DIR/src/{{dotnet_namespace}}.AppHost reference DIR/src/MAIN
  - dotnet add DIR/src/MAIN reference DIR/src/{{dotnet_namespace}}.ServiceDefaults
  - dotnet add DIR/tests/MAIN.Tests reference DIR/src/{{dotnet_namespace}}.AppHost
  - dotnet add DIR/tests/MAIN.Tests package Aspire.Hosting.Testing
  - dotnet sln DIR add DIR/src/{{dotnet_namespace}}.AppHost DIR/src/{{dotnet_namespace}}.ServiceDefaults
---
Aspire (aspire.dev) orchestration for .NET solutions: an AppHost that defines the app's resources, and service defaults for telemetry, health checks and service discovery.

`DIR`, `MAIN` and `dotnet_namespace` are the dotnet stack's; don't ask for them again.

Prerequisite: the Aspire CLI — an AppHost doesn't build without it. Before the generators, run `aspire --version`. If it's missing, show the official install command, `curl -sSL https://aspire.dev/install.sh | bash` (Windows: `irm https://aspire.dev/install.ps1 | iex`), and ask before running it. Don't use `aspire new`: it needs an interactive terminal.
