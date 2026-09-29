### Aspire

- Run the whole app: `aspire run` — starts every resource and prints the dashboard URL.
- AppHost: `{{aspire_apphost}}`
- Add an integration: `aspire add NAME`
- Integration tests: `dotnet test`; they start the AppHost through `Aspire.Hosting.Testing`.
- Requires the Aspire CLI (`aspire --version`).
