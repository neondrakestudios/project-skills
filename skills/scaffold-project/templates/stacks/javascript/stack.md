---
title: JavaScript (Node.js / Bun)
detect:
  - package.json
unless:
  - tsconfig.json
generators:
  - "(mkdir -p DIR && cd DIR && npm init -y)   (alternatives: Node.js with npm)"
  - "(mkdir -p DIR && cd DIR && pnpm init)   (Node.js with pnpm)"
---
Plain JavaScript projects managed through `package.json`, on Node.js or Bun. A project with a `tsconfig.json` is the `typescript` stack instead. `bun init` creates a TypeScript project, so it is offered there, not here; for plain JavaScript on Bun, run the `npm init -y` generator and install with Bun.

Fill the runtime slots from the lockfile at the package root; the generator that ran decides on an empty repo. With neither, ask which runtime.

| Lockfile | `javascript_install` | `javascript_run` |
|---|---|---|
| `bun.lock`, `bun.lockb` | `bun install --frozen-lockfile` | `bun run` |
| `pnpm-lock.yaml` | `pnpm install --frozen-lockfile` | `pnpm run` |
| `yarn.lock` with `.yarnrc.yml` (Yarn 2+) | `yarn install --immutable` | `yarn run` |
| `yarn.lock` without `.yarnrc.yml` (Yarn 1) | `yarn install --frozen-lockfile` | `yarn run` |
| `package-lock.json` | `npm ci` | `npm run` |

Keep a command line only when `package.json` defines that script; drop the rest.
