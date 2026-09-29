### Orleans

- Silo: `{{orleans_silo_project}}`; grains: `{{orleans_grains_project}}`; interfaces and models: `{{orleans_interfaces_project}}`
- Clients reference the interfaces project only, never the grains project.
- Run: through the AppHost when Aspire is used, else start the silo (`dotnet run --project {{orleans_silo_project}}`) before any client.
- Test: `dotnet test`; grain tests use an in-process cluster from `Microsoft.Orleans.TestingHost`.
