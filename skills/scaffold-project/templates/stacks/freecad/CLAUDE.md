### FreeCAD

- Models: `cad/*.FCStd`. Binary to git — never edit one while it's open in the GUI, and commit after each modelling session; two branches can't merge the same model.
- Parameters: every driving dimension is an alias in the `Params` spreadsheet of the file that owns it; features reference aliases, never typed numbers.
- Inspect without FreeCAD: `unzip -p cad/NAME.FCStd Document.xml` — spreadsheet cells and their aliases, and each feature's expressions, are plain XML.
- Script: `FreeCADCmd SCRIPT.py` runs Python headless — to read or set parameters, recompute and export.
- Exports: `exports/` holds STEP for exchange and STL for printing, regenerated from the model; dimensioned drawings go to {{#docs}}`docs/drawings/`{{/docs}}{{^docs}}`exports/`{{/docs}} as PDF.
- Expected layout: `cad/` for models and macros, `exports/` for generated files.
