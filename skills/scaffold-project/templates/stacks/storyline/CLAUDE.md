### StoryLine

{{^series}}
- Project: `{{writing_vault}}/{{storyline_root}}/TITLE.md`, with `TITLE/` beside it holding `Scenes/`, `Codex/` (`Characters/`, `Locations/` and custom categories), `Research/`, `Notes/` (corkboard), `Archive/` (cut scenes), `System/` (plugin state) and `Exports/`.
{{/series}}
{{#series}}
- Series: `{{writing_vault}}/{{storyline_root}}/SERIES/` holds `series.json` (the manifest: its books and their order), one shared `Codex/` (`Characters/`, `Locations/` and custom categories), and each book as `BOOK.md` with `BOOK/` beside it holding `Scenes/`, `Research/`, `Notes/` (corkboard), `Archive/` (cut scenes), `System/` (plugin state) and `Exports/`. Books are created, added, reordered and renamed only with StoryLine's series commands; never edit `series.json` or move a book by hand.
- The shared `Codex/` serves every book: a character, location or world entry is written once there, never copied into a book. An entry StoryLine restricts to one book belongs to that book; don't use it in another.
- Cross-book items — plot threads, mysteries, foreshadowing, promises to the reader — are entries in custom categories of the shared `Codex/`, one note per item, each recording the books it appears in and where it is set up and paid off. Scenes link to them with `[[wikilinks]]`. Before drafting or revising a scene, read the items it links to. Report a scene that resolves, contradicts or drops an open item.
{{/series}}
- Scenes are Markdown with `type: scene` frontmatter that StoryLine owns: `act`, `chapter`, `sequence`, `status` (`idea` → `outlined` → `draft` → `written` → `revised` → `final`), `pov`, `characters` and `location` as `[[wikilinks]]`, and more. Edit a field only to the value the author asked for. Never edit `wordcount`, or anything in `System/`.
{{^series}}
- Reference material goes in `Research/`, brainstorming in `Notes/`, characters and world in `Codex/`.
- Progress, scenes per status: `find "{{writing_vault}}/{{storyline_root}}" -path '*/Scenes/*.md' -exec grep -h '^status:' {} + | sort | uniq -c`.
{{/series}}
{{#series}}
- A book's own reference material goes in its `Research/` and brainstorming in its `Notes/`; anything the whole series relies on goes in the shared `Codex/`.
- Progress, scenes per status: for the series, `find "{{writing_vault}}/{{storyline_root}}" -path '*/Scenes/*.md' -exec grep -h '^status:' {} + | sort | uniq -c`; for one book, `find "{{writing_vault}}/{{storyline_root}}/SERIES/BOOK/Scenes" -name '*.md' -exec grep -h '^status:' {} + | sort | uniq -c`.
{{/series}}
- Obsidian's "Automatically update internal links" must stay on; StoryLine relies on it when scenes and codex entries move, and refuses to create or join a series without it.
- Expected layout: `{{writing_vault}}/` with `.obsidian/` and the StoryLine root folder{{#series}} holding the series folder{{/series}}.
