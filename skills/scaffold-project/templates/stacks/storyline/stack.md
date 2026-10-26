---
title: StoryLine (Obsidian)
kind: writing
detect:
  - glob: "community-plugins.json"
    contains: storyline
flags:
  - series
---
Books planned and written with the StoryLine Obsidian plugin in the `manuscript/` vault.

No generator: Obsidian installs the plugin, and StoryLine creates the project. Under "Needs your decision", list the steps: open `manuscript/` as a vault in Obsidian, turn on community plugins, install StoryLine from Settings → Community plugins → Browse, then use its ribbon icon to create the project. When `series` is true, add: then run **Create Series from Current Project** from the command palette, and add later books with **Add Current Project to Series**. Never download plugin code or write the plugin's `data.json` or `series.json`.

The committed `community-plugins.json` only enables StoryLine once it is installed. Its code — `main.js`, `manifest.json`, `styles.css` — is ignored; its settings, `data.json`, are committed.

Fill `storyline_root` from `storyLineRoot` in `manuscript/.obsidian/plugins/storyline/data.json`, else `StoryLine`.

The `series` flag — whether the books form a StoryLine series with a shared Codex — is true when a `series.json` exists under `manuscript/{{storyline_root}}/`, else from a `series=yes|no` argument, else asked once after the stacks are chosen: "Is this book part of a series?" In a dry run with neither, it is false, and the report lists the question under "Needs your decision".

On a scaffolded repo where a `series.json` exists but the StoryLine section has no `- Series:` line, the section is not changed: list under "Needs your decision" that the book became a series, with the series lines of the fragment rendered, to add by hand.
