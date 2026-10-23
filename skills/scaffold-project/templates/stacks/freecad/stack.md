---
title: FreeCAD
kind: cad
detect:
  - "*.FCStd"
  - "*.FCMacro"
---
Parametric CAD models built in FreeCAD.

No generator: models are created in the FreeCAD GUI. The skill creates no `cad/` or `exports/` folders — they appear with the first model.

Prerequisite for the scripted commands only: `FreeCADCmd` (the console build, shipped with FreeCAD; `freecadcmd` on some Linux packages). Check with `FreeCADCmd --version` and report if missing — it isn't needed to scaffold.

`.FCStd` files are zip archives and binary to git: they can't be diffed or merged. Under "Needs your decision", list whether to track them with Git LFS (`git lfs track "*.FCStd"`), and never run it.
