
## Orleans

### Project boundaries
Grain interfaces and the types they exchange live in `{{dotnet_namespace}}.Orleans.Interfaces`; implementations live in `{{dotnet_namespace}}.Orleans.Grains`. Clients reference the interfaces project only.

### Grains
<!-- Key types, grain granularity, what may and may not block inside a grain. -->

### State and serialization
<!-- Storage providers, [GenerateSerializer]/[Id]/[Alias] rules, how persisted state is versioned. -->

### Clustering and hosting
<!-- Local clustering vs production providers, and how the silo is wired (UseOrleans, Aspire). -->

### Testing
<!-- Behavior specs call grains through their interfaces on a test cluster; unit-test pure logic outside grains. -->
