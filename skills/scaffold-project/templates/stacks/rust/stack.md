---
title: Rust
detect:
  - Cargo.toml
generators:
  - "cargo init DIR --name {{project_name}}         (alternatives: binary)"
  - "cargo init DIR --lib --name {{project_name}}   (library)"
---
Rust crates and workspaces built with Cargo.
