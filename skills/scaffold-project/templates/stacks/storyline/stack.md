---
title: StoryLine (Obsidian)
kind: writing
detect:
  - glob: "community-plugins.json"
    contains: storyline
---
Books planned and written with the StoryLine Obsidian plugin in the `manuscript/` vault.

No generator: Obsidian installs the plugin, and StoryLine creates the project. Under "Needs your decision", list the steps: open `manuscript/` as a vault in Obsidian, turn on community plugins, install StoryLine from Settings → Community plugins → Browse, then use its ribbon icon to create the project. Never download plugin code or write the plugin's `data.json`.

The committed `community-plugins.json` only enables StoryLine once it is installed. Its code — `main.js`, `manifest.json`, `styles.css` — is ignored; its settings, `data.json`, are committed.

Fill `storyline_root` from `storyLineRoot` in `manuscript/.obsidian/plugins/storyline/data.json`, else `StoryLine`.
