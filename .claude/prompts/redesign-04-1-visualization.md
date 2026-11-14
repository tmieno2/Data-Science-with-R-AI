Redesign the first data visualization lecture for my Data Science course, in the same spirit as the data import/export lecture that has already been redesigned.

## Background

I am overhauling my Data Science with R course (AECN 896-05) for 2027 and teaching it as a flipped course: students study the lecture deck before class and work on an exercise in class. AI now writes most code, so the course teaches:

1. **The concept**: what the step is, and what has to be true for it to succeed.
2. **Reading code**: enough to recognise what a line does, not to write it from memory.
3. **Asking AI**: what the AI cannot know (what the data contains, what question the figure must answer, what the reader needs) and so must be told.
4. **Checking**: concrete checks whose correct answer the student knows in advance.

**The core principle of the whole course:** work lives in a Quarto document (`.qmd`). The AI writes code into it, with one plain-English sentence above each chunk. The student renders it and judges the work by reading the HTML, not the chat window. Every recommended request ends with the same "closing instructions".

## Read these first, in this order

1. `~/Teaching/CLAUDE.md` and `~/Teaching/Data-Science-with-R-AI/CLAUDE.md` (the new course; its "teaching approach" section is the brief).
2. The finished model to copy the structure and tone from:
   - Deck: `~/Teaching/Data-Science-with-R-AI/lectures/Chapter-3-DataWrangling/03-1-input-output.qmd`
   - Exercise web page: `~/Teaching/Data-Science-with-R-AI/exercises/3-1-input-output.qmd`
   - Worksheet: `~/Teaching/Data-Science-with-R-AI/exercises/worksheets/ex-3-1.qmd`
3. The deck to redesign: `~/Teaching/Data-Science-with-R-Quarto/lectures/Chapter-4-Data-Visualization/04-1-data-visualization-basics.qmd`. Read it in full. Also skim `04-2-more-information.qmd` and `04-3-fine-tuning.qmd` in the same folder, so 04-1 does not take over their topics.
4. `~/Teaching/Data-Science-with-R-Quarto/CLAUDE.md`, section "Traps that have already cost time". Those traps apply to the new repo too.

The old course repo is read-only for this task. All writing happens in `~/Teaching/Data-Science-with-R-AI/`.

## What to produce

1. `lectures/Chapter-4-Data-Visualization/04-1-data-visualization-basics.qmd`, a rewritten deck with the same section shape as 03-1: How this lecture works, The concept, Asking AI, Checking the result, Recommended requests, Summary.
2. `exercises/4-1-data-visualization-basics.qmd`, the exercise web page: setup, download links, and collapsed answer boxes whose numbers are computed from the data at render time.
3. `exercises/worksheets/ex-4-1.qmd`, the fill-in worksheet, where every task runs Look, Predict, Ask (from a recommended request with `<...>` blanks), Render and read the HTML.
4. Any data file the exercise needs, plus the short script that made it if you construct one.

## The content I want in the deck

Concepts, not syntax. Function names appear as samples to recognise. Candidates (use your judgement after reading the old deck):

- What a figure is made of: the data, the **mapping** (which column is shown by which visual property: position, colour, size, shape), and the kind of mark (points, lines, bars). Name these once and use the same names throughout.
- What must be true of the data before a figure can be right: one row per thing being drawn, a column for every variable you want to show, and the right type for each (a category stored as a number gets a colour gradient instead of distinct colours).
- Which kind of figure answers which kind of question: distribution, relationship between two variables, comparison across groups, change over time.
- What a reader needs: axis titles with units, a readable legend, a title that states the finding.
- Silent failures, shown with real output. For example: a numeric code mapped to colour; bars that silently count rows instead of showing a value; data with several rows per group drawn as one jagged line; points hidden on top of each other; a figure built from the wrong filtered subset.
- Checking a figure: ask the AI to print, next to the figure in the HTML, the data the figure is built from (or a summary of it), and compare it with what you expect: number of points or bars, axis ranges against the data's minimum and maximum, one known value found on the figure.
- Recommended requests with `<...>` blanks for: making a figure that answers a stated question, checking that a figure matches its data, improving a figure for a reader, and explaining someone else's plotting code. Each request ends with the closing instructions **copied word for word** from the "Closing instructions" tab of the 03-1 deck.

## Rules (from me, for everything you write)

1. Plain language: write as for a smart person who has not seen the code. Use a technical term only when the student needs it, and define it in parentheses where it first appears. Literal and exact, never metaphorical: no invented nicknames or images for mechanisms. One name per thing, used consistently.
2. No em-dashes anywhere. Use a comma, a semicolon, or a new sentence.
3. Every figure is ggplot2. Never base R plotting.
4. Never put two visible code blocks back to back; put a sentence or a heading between them.
5. A short side point goes inside the tab it belongs to, never in a tab of its own.
6. Lead each slide with what is needed and how to tell it is done, not with step-by-step how.
7. Every number or claim in the prose about what code outputs must match what the rendered output shows. Compute numbers with inline R where you can, so they cannot drift. Before you write that a trap behaves a certain way (for example, "the AI's likely code does X"), run that code and confirm it does. In the 03-1 redesign, one such claim turned out false when tested.
8. Do not write transcripts for now. I will decide on them after reviewing the deck.
9. Keep plain `{r}` chunks, as 03-1 does. The old 04-1 uses WebR (code that runs in the browser); the new repo does not have the WebR extension set up. If you think WebR is worth it for this deck, say so and why, and do not set it up yourself.

## Process

1. After reading, show me an outline of the deck and of the exercise tasks, as numbered lists. Wait for my approval before writing the files.
2. Write the three files.
3. Render the whole site from the repo root, redirecting output, never piping it: `quarto render > <log file> 2>&1; echo "EXIT: $?"`. It must exit 0.
4. Check every answer-box number and every output claim against the rendered HTML.
5. Copy the blank worksheet into a mock student project (a folder with an empty `.Rproj`, `analysis/` and `data/`) in your scratch directory and confirm it renders unchanged.
6. Commit in `~/Teaching/Data-Science-with-R-AI` and push to its `origin`.
7. Report back in plain language, with labelled items: what is in the deck and the exercise, what you cut from the old deck and why, anything about the data that surprised you, and any decisions you need from me, each labelled so I can answer by letter.
