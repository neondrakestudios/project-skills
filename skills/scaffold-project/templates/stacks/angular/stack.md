---
title: Angular
detect:
  - angular.json
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
