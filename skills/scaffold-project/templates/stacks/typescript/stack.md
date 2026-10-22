---
title: TypeScript (Node.js / Bun)
detect:
  - tsconfig.json
unless:
  - angular.json
gitignore:
  - Node.gitignore
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

**Container support** (see step 6 of the skill). No official generator the skill can run creates container files, so render `Dockerfile.template` in each app's folder, built with that folder as the context. `BUILD_CONFIGURATION` defaults to `production` and becomes `NODE_ENV` at run time; `tini` runs as PID 1 so stop signals reach the app.

- `container_image`: `docker.io/library/node:MAJOR-alpine` — the Node major from `.nvmrc` or `engines.node`, else the current LTS — or `docker.io/oven/bun:1-alpine` for a Bun lockfile.
- `container_manifest_files`: `package.json` and the lockfile.
- `container_install`: `npm ci`, `bun install --frozen-lockfile`, `corepack enable && pnpm install --frozen-lockfile`, or `corepack enable && yarn install` with `--immutable` (Yarn 2+) or `--frozen-lockfile` (Yarn 1). Corepack ships with Node up to 24; on later images, install pnpm or Yarn with `npm install -g`.
- `container_build`: `RUN <run> build` when `package.json` has a `build` script; otherwise leave it out.
- `container_prune`: `RUN npm prune --omit=dev`, `RUN pnpm prune --prod`, or for Bun `RUN rm -rf node_modules && bun install --frozen-lockfile --production`. For Yarn, leave it out and report it.
- `container_user`: `node` on Node images, `bun` on Bun images.
- `container_expose`: `EXPOSE PORT` for the port the app listens on; leave it out when it serves nothing.
- `container_cmd`: the exec form of what `start` runs — `["node", "dist/index.js"]`, `["bun", "index.ts"]` — never `npm start`.
- A `compose.yaml` service per app: `container_context` is the app's folder, and `container_ports` is `    ports:\n      - "HOST:PORT"` when it exposes a port.
