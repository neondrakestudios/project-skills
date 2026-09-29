### Rust

- Build: `cargo build`
- Test: `cargo test`
- Lint: `cargo clippy --all-targets -- -D warnings`
- Format: `cargo fmt --check`
- Run: `cargo run`
- Expected layout: `Cargo.toml` at the root, `src/main.rs` or `src/lib.rs`, integration tests under `tests/`; workspace members under `crates/`.
