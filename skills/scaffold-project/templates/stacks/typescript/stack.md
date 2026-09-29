---
title: TypeScript (Node.js / Bun)
detect:
  - tsconfig.json
unless:
  - angular.json
generators:
  - "(mkdir -p DIR && cd DIR && npm init -y && npm install -D typescript @types/node && npx tsc --init)   (alternatives: Node.js with npm)"
  - "(mkdir -p DIR && cd DIR && pnpm init && pnpm add -D typescript @types/node && pnpm exec tsc --init)   (Node.js with pnpm)"
  - "(mkdir -p DIR && cd DIR && bun init -y)   (Bun; its template is TypeScript and adds @types/bun)"
---
TypeScript projects managed through `package.json`, on Node.js or Bun. An Angular workspace is the `angular` stack instead. Type packages: `typescript` and `@types/node` on Node.js; `@types/bun` on Bun, which runs TypeScript directly.

Fill the runtime slots from the lockfile at the package root; the generator that ran decides on an empty repo. With neither, ask which runtime.

| Lockfile | `typescript_install` | `typescript_run` | `typescript_exec` |
|---|---|---|---|
| `bun.lock`, `bun.lockb` | `bun install --frozen-lockfile` | `bun run` | `bunx` |
| `pnpm-lock.yaml` | `pnpm install --frozen-lockfile` | `pnpm run` | `pnpm exec` |
| `yarn.lock` with `.yarnrc.yml` (Yarn 2+) | `yarn install --immutable` | `yarn run` | `yarn` |
| `yarn.lock` without `.yarnrc.yml` (Yarn 1) | `yarn install --frozen-lockfile` | `yarn run` | `yarn` |
| `package-lock.json` | `npm ci` | `npm run` | `npx` |

Keep a script command line only when `package.json` defines that script; drop the rest. Keep the typecheck line whenever `typescript` is a dependency.
