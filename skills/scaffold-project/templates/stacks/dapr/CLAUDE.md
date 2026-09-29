### Dapr

- Run all apps: `dapr run -f .` (reads `dapr.yaml`); with Aspire, `aspire run` starts the sidecars instead.
- Run one app: `dapr run --app-id ID --app-port PORT -- COMMAND`
- Inspect: `dapr list`; stop: `dapr stop -f .`
- Components: `{{dapr_components_dir}}`
- Requires the Dapr CLI and runtime (`dapr --version`).
