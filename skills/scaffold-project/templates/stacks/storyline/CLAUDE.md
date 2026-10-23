### StoryLine

- Project: `manuscript/{{storyline_root}}/TITLE.md`, with `TITLE/` beside it holding `Scenes/`, `Codex/` (`Characters/`, `Locations/` and custom categories), `Research/`, `Notes/` (corkboard), `Archive/` (cut scenes), `System/` (plugin state) and `Exports/`. A series adds `SERIES/series.json` and a shared `Codex/`.
- Scenes are Markdown with `type: scene` frontmatter that StoryLine owns: `act`, `chapter`, `sequence`, `status` (`idea` → `outlined` → `draft` → `written` → `revised` → `final`), `pov`, `characters` and `location` as `[[wikilinks]]`, and more. Edit a field only to the value the author asked for. Never edit `wordcount`, or anything in `System/`.
- Reference material goes in `Research/`, brainstorming in `Notes/`, characters and world in `Codex/`.
- Progress, scenes per status: `find "manuscript/{{storyline_root}}" -path '*/Scenes/*.md' -exec grep -h '^status:' {} + | sort | uniq -c`.
- Obsidian's "Automatically update internal links" must stay on; StoryLine relies on it when scenes and codex entries move.
- Expected layout: `manuscript/` with `.obsidian/` and the StoryLine root folder.
