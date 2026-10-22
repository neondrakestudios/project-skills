---
title: Elixir
detect:
  - mix.exs
gitignore:
  - Elixir.gitignore
generators:
  - "mix new DIR --app {{project_name}}   (alternatives: plain Mix project)"
  - "mix phx.new DIR --app {{project_name}} --install   (Phoenix; needs `mix archive.install hex phx_new`)"
container_generators:
  - "(cd DIR && mix phx.gen.release --docker)   (Phoenix apps only; official)"
---
Elixir projects built with Mix, including Phoenix applications.

`--app` needs a snake_case name: convert `project_name` before running a generator.

**Container support** (see step 6 of the skill). For a Phoenix app, offer the official `mix phx.gen.release --docker`, which writes a `Dockerfile` and `.dockerignore`; it picks its own base images, so its output doesn't follow the Alpine and build-argument shape, and isn't edited. For another app with a supervision tree (`mod:` in `mix.exs`), no official generator exists, so render `Dockerfile.template`: a Mix release built on `hexpm/elixir` and run on the matching `alpine` as a non-root user. Libraries get no container. `BUILD_CONFIGURATION` is `MIX_ENV` and defaults to `prod`.

- `container_elixir_tag`: a `hexpm/elixir` tag `ELIXIR-erlang-OTP-alpine-ALPINE` matching the project's Elixir and OTP versions; list candidates from `https://hub.docker.com/v2/repositories/hexpm/elixir/tags?name=erlang-OTP`.
- `container_alpine_version`: the Alpine version in that tag — the runtime must match the build's C libraries.
- `container_app`: the application name from `mix.exs`.
- A `compose.yaml` service with `container_context` as the app's folder, and `container_ports` when it listens on a port (Phoenix defaults to 4000).
