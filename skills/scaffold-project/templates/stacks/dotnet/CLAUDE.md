### .NET

- Build: `dotnet build`
- Test: `dotnet test`
- Run: `dotnet run --project {{dotnet_startup_project}}`
- Format: `dotnet format --verify-no-changes`
- Expected layout: solution file at the root, projects under `src/`, test projects under `tests/` mirroring `src/`. Projects are named `{{dotnet_namespace}}.ROLE`, and tests `{{dotnet_namespace}}.ROLE.Tests`.
