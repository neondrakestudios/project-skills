---
title: Rust
detect:
  - Cargo.toml
gitignore:
  - Rust.gitignore
generators:
  - "cargo init DIR --name {{project_name}}         (alternatives: binary)"
  - "cargo init DIR --lib --name {{project_name}}   (library)"
---
Rust crates and workspaces built with Cargo.

**Container support** (see step 6 of the skill). No official generator the skill can run creates container files, so render `Dockerfile.template` for each binary crate (`src/main.rs` or a `[[bin]]` target), never for libraries. The build runs on `rust:VERSION-alpine`, producing a static musl binary that runs on `alpine:3` as a non-root user. `BUILD_CONFIGURATION` is the Cargo profile and defaults to `release`.

- `rust_version`: the channel in `rust-toolchain.toml`, else `rust-version` in `Cargo.toml`, else `1`.
- `container_crate_path`: `.` for a single crate; the member's path, built from the workspace root, in a workspace.
- `container_binary`: the binary's name.
- `container_expose`: `EXPOSE PORT` when it listens on a port; otherwise leave it out.
- `cargo install --locked` needs a committed `Cargo.lock`; if there is none, report it.
- A `compose.yaml` service with `container_context` as the build context, and `container_ports` as `    ports:\n      - "HOST:PORT"` when it exposes one.
