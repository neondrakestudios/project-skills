---
status: Accepted
date: 2026-09-28
supersedes:
superseded-by:
---

# ADR-0005: Plugin and marketplace naming

## Context
Claude Code namespaces a plugin's skills by the manifest `name` (`/NAME:skill`), installs by the marketplace entry name (`ENTRY@MARKETPLACE`), and allows the two names to differ. The plugin is meant to hold more skills later.

## Decision
Manifest `name` is `neondrake`, so skills run as `/neondrake:…`. The repo is its own marketplace, `neondrake`, listing the plugin as `project-skills`, so it installs as `project-skills@neondrake`. The GitHub repo is `neondrakestudios/project-skills`. Descriptions describe the plugin and marketplace, not one skill.

## Consequences
`/plugin` lists the plugin as `project-skills`; a `--plugin-dir` session identifies it as `neondrake`. New skills need no naming change.

## Alternatives considered
Plugin named `scaffold-project` — the command would be `/scaffold-project:scaffold-project`.
