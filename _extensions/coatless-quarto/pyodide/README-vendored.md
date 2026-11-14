# Vendored quarto-pyodide

Copied from https://github.com/coatless-quarto/pyodide, main branch, commit
ab8ce496656e9daeffd3f5a6ce9d0c4d5c692aab (2026-11-06), which loads Pyodide 0.27.2.
Licence: AGPL-3.0-or-later (`LICENSE`) with the Quarto Rendered Output Exception
(`LICENSE-EXCEPTION.md`); keep both files here.

Local changes, each marked `PATCHED` where it is made:

1. `_extension.yml`: `quarto-required` relaxed from `>=1.11.0` to `>=1.4.0`.
   The course renders with Quarto 1.7, and the extension works there.
2. `qpyodide-cell-classes.js`: the Monaco editor gets the same settings as the
   course's patched WebR editor (0.7 of the slide's body text, a narrow
   line-number margin, no overview ruler, word wrap on), and its height is not
   set while the cell is hidden and 0 px wide. See `lectures/RULES.md`, sections
   2 and 7.
3. `qpyodide-cell-classes.js`, output: the value of a last bare expression is
   shown with Python's `repr()` (upstream showed `True` as `true`); an error
   shows only the last line of its traceback (`TypeError: ...`); output is
   inserted as text, not HTML, so `<class 'str'>` is not swallowed as a tag.
4. `qpyodide-monaco-editor-init.html` and `qpyodide.lua`: Monaco 0.47.0, the
   version the WebR extension loads, and its loader is skipped when WebR has
   already loaded it.

Re-apply these if the extension is ever updated.
