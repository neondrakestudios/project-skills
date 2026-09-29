---
title: Dapr
detect:
  - dapr.yaml
  - glob: "*.yaml"
    contains: dapr.io/v1alpha1
generators:
  - "dotnet add DIR/src/MAIN package Dapr.AspNetCore   (only when dotnet is also chosen; after the dotnet generators)"
  - "dotnet add DIR/src/{{dotnet_namespace}}.AppHost package CommunityToolkit.Aspire.Hosting.Dapr   (only when aspire is also chosen; after the aspire generators)"
---
Dapr sidecar building blocks — service invocation, state, pub/sub, actors, workflows — for services in any language.

Prerequisite: the Dapr CLI with an initialized runtime (Docker). Run `dapr --version`; if the CLI is missing, or reports no runtime version, show `dapr init` and ask before running it — it sets up the machine, not the repo. Never write component or `dapr.yaml` files: they depend on choices the user hasn't made; list them under "Needs your decision" instead.

`DIR`, `MAIN` and `dotnet_namespace` for the .NET commands are the dotnet stack's.

Fill `dapr_components_dir` from `resourcesPaths` in `dapr.yaml`, else the folder holding component YAML, else TODO. Keep the `dapr run -f` and `dapr stop -f` lines only when `dapr.yaml` exists.
