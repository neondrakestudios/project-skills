---
title: Elixir
detect:
  - mix.exs
generators:
  - "mix new DIR --app {{project_name}}   (alternatives: plain Mix project)"
  - "mix phx.new DIR --app {{project_name}} --install   (Phoenix; needs `mix archive.install hex phx_new`)"
---
Elixir projects built with Mix, including Phoenix applications.

`--app` needs a snake_case name: convert `project_name` before running a generator.
