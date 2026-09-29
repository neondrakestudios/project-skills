---
title: Orleans
requires:
  - dotnet
detect:
  - glob: "*.csproj"
    contains: Microsoft.Orleans
generators:
  - "dotnet new classlib -o DIR/src/{{dotnet_namespace}}.Orleans.Interfaces   (sequence: run all, in order, after the dotnet generators)"
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Interfaces package Microsoft.Orleans.Sdk
  - dotnet new classlib -o DIR/src/{{dotnet_namespace}}.Orleans.Grains
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Grains package Microsoft.Orleans.Sdk
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Grains package Microsoft.Extensions.Logging.Abstractions
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Grains reference DIR/src/{{dotnet_namespace}}.Orleans.Interfaces
  - dotnet new worker -o DIR/src/{{dotnet_namespace}}.Orleans.Silo
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Silo package Microsoft.Orleans.Server
  - dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Silo reference DIR/src/{{dotnet_namespace}}.Orleans.Grains
  - dotnet add DIR/src/MAIN package Microsoft.Orleans.Client
  - dotnet add DIR/src/MAIN reference DIR/src/{{dotnet_namespace}}.Orleans.Interfaces
  - dotnet new nunit -o DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests
  - dotnet add DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests reference DIR/src/{{dotnet_namespace}}.Orleans.Grains
  - dotnet add DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests package Microsoft.Orleans.TestingHost
  - dotnet add DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests package Reqnroll.NUnit
  - dotnet add DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests package AwesomeAssertions
  - dotnet add DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests package NSubstitute
  - dotnet sln DIR add DIR/src/{{dotnet_namespace}}.Orleans.Interfaces DIR/src/{{dotnet_namespace}}.Orleans.Grains DIR/src/{{dotnet_namespace}}.Orleans.Silo DIR/tests/{{dotnet_namespace}}.Orleans.Grains.Tests
  - "dotnet add DIR/src/{{dotnet_namespace}}.AppHost package Aspire.Hosting.Orleans   (only when aspire is also chosen; this and the next two run after the aspire generators)"
  - "dotnet add DIR/src/{{dotnet_namespace}}.AppHost reference DIR/src/{{dotnet_namespace}}.Orleans.Silo   (only when aspire is also chosen)"
  - "dotnet add DIR/src/{{dotnet_namespace}}.Orleans.Silo reference DIR/src/{{dotnet_namespace}}.ServiceDefaults   (only when aspire is also chosen)"
---
Microsoft Orleans virtual-actor applications. Orleans ships as NuGet packages, not a project template. The layout follows the Orleans docs, with every Orleans project under a shared `{{dotnet_namespace}}.Orleans.` prefix so they group together in the solution:

- `Orleans.Interfaces` — grain interfaces and the serializable types they exchange; the only Orleans project clients reference.
- `Orleans.Grains` — grain implementations.
- `Orleans.Silo` — the host that runs the grains.
- The dotnet stack's main project (`MAIN`, e.g. the API) is an Orleans client: it references `Orleans.Interfaces` only, never `Orleans.Grains`.

`DIR`, `MAIN` and `dotnet_namespace` are the dotnet stack's; don't ask for them again.
