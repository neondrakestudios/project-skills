
## .NET

### Language and build
<!-- C# version, nullable, implicit usings, warnings-as-errors — what Directory.Build.props enforces. -->

### Packages
Versions are managed centrally in `Directory.Packages.props`. Add packages with `dotnet add package`; never put a `Version` on a `PackageReference`.

### Project structure
<!-- How projects are split and which may reference which. -->

### Dependency injection and configuration
<!-- Registration pattern, options binding, where secrets come from. -->

### Errors and logging
<!-- Exception policy, result types, structured logging conventions. -->

### Testing

- NUnit for the test runner, including data-driven `[TestCase]` and `[TestCaseSource]` tests for granular cases.
- Reqnroll for BDD/Gherkin `.feature` specs that describe behaviors and run on NUnit via `Reqnroll.NUnit`.
- AwesomeAssertions, the MIT fork of FluentAssertions, for readable assertions.
- NSubstitute for mocking when needed.

### Testing strategy

Use a BDD-led hybrid strategy.

Reqnroll `.feature` scenarios should describe behaviors and double as living documentation. NUnit data-driven tests should cover high-volume, low-level cases where Gherkin would become repetitive or too noisy.

Prefer behavior-focused tests around externally visible outcomes. Use lower-level NUnit cases for validators, mappers and edge cases.
