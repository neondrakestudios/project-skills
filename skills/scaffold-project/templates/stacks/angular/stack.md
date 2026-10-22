---
title: Angular
detect:
  - angular.json
gitignore:
  - Node.gitignore
generators:
  - "npx --yes @angular/cli@latest new {{project_name}} --directory DIR --skip-git --package-manager PM   (sequence: run both; ask for PM: npm, pnpm, yarn or bun)"
  - "(cd DIR && npx --yes ng add angular-eslint --skip-confirmation)   (adds the lint target)"
---
Angular single-page applications built with the Angular CLI.

Fill the runtime slots from the lockfile beside `angular.json`; the `--package-manager` given to the generator decides on an empty repo. With neither, ask which package manager.

| Lockfile | `angular_install` | `angular_exec` |
|---|---|---|
| `bun.lock`, `bun.lockb` | `bun install --frozen-lockfile` | `bunx` |
| `pnpm-lock.yaml` | `pnpm install --frozen-lockfile` | `pnpm exec` |
| `yarn.lock` with `.yarnrc.yml` (Yarn 2+) | `yarn install --immutable` | `yarn` |
| `yarn.lock` without `.yarnrc.yml` (Yarn 1) | `yarn install --frozen-lockfile` | `yarn` |
| `package-lock.json` | `npm ci` | `npx` |

Keep the Lint line only when `angular.json` defines a `lint` target; drop it otherwise.

**Container support** (see step 6 of the skill). No official generator the skill can run creates container files, so render `Dockerfile.template` and `nginx.conf.template` (as `nginx.conf`) in the app's folder, built with that folder as the context. The image builds on Node and serves the static browser output from unprivileged nginx on port 8080, with unknown paths falling back to `index.html`. `BUILD_CONFIGURATION` defaults to `production` and is passed to `ng build --configuration`.

- `container_node_image`: `docker.io/library/node:MAJOR-alpine`, the Node major from `.nvmrc` or `engines.node`, else the current LTS.
- `container_manifest_files`, `container_install`: `package.json`, the lockfile, and the install command from the lockfile table above.
- `container_ng`: `angular_exec` plus ` ng`, e.g. `npx ng`.
- `container_project`: the project name in `angular.json`; the output is `dist/PROJECT/browser` unless `outputPath` says otherwise.
- A server-rendered app (`outputMode: "server"` or an `ssr` entry in `angular.json`) needs a Node runtime instead of nginx: don't render, and list it under "Needs your decision".
- A `compose.yaml` service with `container_context` as the app's folder and its own `container_host_port`.
