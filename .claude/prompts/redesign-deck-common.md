# Redesigning a lecture deck for the 2027 course: the common brief

Every agent redesigning a deck reads this first. Your own prompt names the decks you own.

## Background

**The student's role, which every deck revolves around.** The student is the
generalist in charge of a research project; AI agents do the work. The student
must know enough to direct them (what to ask for, what the agent cannot know
and must be told) and to evaluate what comes back (which checks, with which
right answers). Every slide earns its place by serving one of those two. Teach
what a step is and what must be true for it to work; do not teach procedures
the agent carries out (installing, syntax rules, menu clicks) beyond what the
student must recognise in the agent's code and messages. (Ruled 2026-11-14.)

The Data Science with R course (AECN 896-05) is being overhauled for 2027 and taught flipped: students study each deck alone before class, then work through an exercise in class with an AI assistant. AI now writes most code, so each deck teaches:

1. **The concept**: what the step is, and what has to be true for it to succeed.
2. **Reading code**: the general pattern of the code the AI will write, and enough to recognise what a line does. Never writing it from memory.
3. **Asking AI**: what the AI cannot know (where files are, what is in the data, what the result is for, who reads it) and so must be told.
4. **Checking**: what to ask the AI to check and why, with checks whose correct answer the student knows in advance.

**The core principle is a workflow for students' own research, which the course practises:** the AI writes code into a Quarto document (`.qmd`), with one plain-English sentence above each chunk; the student renders it and judges the work by reading the HTML, not the chat window. Present it as how to do research with AI, never as a rule of this course. Every recommended request that asks for code ends with the "closing instructions", copied **word for word** from the "Closing instructions" tab of the "Requests you can copy" slide in 03-1.

## Read these first

1. `~/Teaching/CLAUDE.md` and `~/Teaching/Data-Science-with-R-AI/CLAUDE.md`.
2. The finished model. Copy its structure, tone and level:
   - Deck: `~/Teaching/Data-Science-with-R-AI/lectures/Chapter-3-DataWrangling/03-1-input-output.qmd`
   - Exercise page: `~/Teaching/Data-Science-with-R-AI/exercises/3-1-input-output.qmd`
   - Worksheet: `~/Teaching/Data-Science-with-R-AI/exercises/worksheets/ex-3-1.qmd`
   - `git -C ~/Teaching/Data-Science-with-R-AI show 5fb2086` shows what a review of 03-1 found and fixed. Do not repeat those mistakes.
3. Your decks in the old course, `~/Teaching/Data-Science-with-R-Quarto/lectures/...`, read in full. They are read-only. They are mostly about syntax; reshape them, do not trim them.
4. `~/Teaching/Data-Science-with-R-Quarto/CLAUDE.md`, section "Traps that have already cost time".
5. The old exercises for your topic, if any, in `~/Teaching/Data-Science-with-R-Quarto/exercises/`.

## What to produce, per deck

1. The rewritten deck at the same relative path under `~/Teaching/Data-Science-with-R-AI/lectures/` (keep the file name). Keep 03-1's "How this lecture works" and "Summary", and order the middle to suit the topic. Include an Asking AI part and Recommended requests only where they teach something: what the student must tell the AI that it cannot know (the data, the purpose, the checks). Never add a request for something the AI already knows how to do, such as installing a package; teach the concept instead, so the student understands what the AI says.
2. An exercise web page `exercises/N-N-topic.qmd` and worksheet `exercises/worksheets/ex-N-N.qmd`, following 03-1's pattern exactly (resources in YAML, a hidden answers chunk, collapsed answer boxes with numbers computed at render). Use the deck's number for N-N. If a deck is pure setup (installing software) and an exercise would be only "install it", say so in your report and write a short setup checklist page instead of a worksheet.
3. Data files the deck or exercise needs, copied or constructed inside the new repo. Name exercise data files with the deck number prefix (for example `exercises/data/5-1-...csv`), since other agents write into `exercises/data/` at the same time. If you construct one, keep the script that made it in `exercises/data-prep/`.

## Rules that 03-1's review taught

1. **Show the general pattern before any single example.** For each kind of code the deck covers: one slide with the pattern every variant shares (a template line, a table of its parts and which are required), a table of the common functions that follow it, then one real example. See 03-1's "How reading code is written".
2. **Blanks in recommended requests are never filled in**, and they describe what goes there: `<path to the file>`, `<number>`, `<the column that identifies each county>`. Never put this deck's or the exercise's real values in a blank.
3. **The closing instructions are identical everywhere**, at the end of every request that asks for code, including example requests on other slides. In example requests outside the Recommended requests slide, the path and heading may be filled with neutral examples (`analysis/import.qmd`), never with exercise file names or task numbers.
4. **Do not let the deck give away an exercise's main discovery.** If the exercise hinges on finding something in the data, the deck teaches the idea on a different example.
5. **Checks are printed as "name of check: expected X, got Y"** in example code, so the HTML says which passed. If an example check fails, say so; never pass a failed check.
6. **Code shown as "Code the AI wrote" must follow the rules the deck teaches** (paths, checks, a sentence above each chunk where shown as HTML). Paths on slides are bare file names because the data sits beside the deck; say so once.
7. **Every term is defined in parentheses before or where it is first used.** One name per thing for the whole deck ("table", not sometimes "data frame"; "pattern", not sometimes "shape").
8. **Every claim about what code does is true.** Run it and check the rendered output. Compute numbers in prose with inline R so they cannot drift. In 03-1, two claims turned out false when tested.
9. **A student studying alone must be able to follow it.** No reference to the exercise, its files or task numbers from the deck.

## The author's writing rules

1. Plain, literal language, as for a smart person who has not seen the code. No metaphors, invented nicknames or images for mechanisms.
2. No em-dashes anywhere.
3. Every figure is ggplot2, never base R plotting. Palettes readable by colour-blind readers.
4. Never two visible code blocks back to back; put a sentence between them.
5. A short side point goes inside the tab it belongs to, never in a tab of its own.
6. Lead each slide with what is needed and how to tell it is done, not with step-by-step how.
7. No transcripts for now.
8. Plain `{r}` chunks only; no WebR (the new repo does not have it). If you think WebR is worth it for a deck, say so in the report.
9. Options and questions in your report are labelled with numbers or letters, one per line.

## Process

Other agents are working in the same repository at the same time, on other chapters. So:

1. Do **not** wait for approval of an outline; the author is away. Make the call, and list the decisions you made in your report.
2. Touch only your own decks, their exercise pages, worksheets and data files. Never edit `_quarto.yml`, the index pages, `CLAUDE.md`, or any file under `lectures/` that is a synced shared file (`custom.scss`, `notebook.scss`, `transcript-support.html`, `_metadata.yml`, `RULES.md`, and so on).
3. Render **only your own files**, one at a time, from the repo root: `quarto render <path/to/file.qmd> > <your scratch log> 2>&1; echo "EXIT: $?"`. Never pipe `quarto render`. Never render the whole site; the main session does that at the end.
4. Check every answer-box number and every output claim against the rendered HTML in `docs/`.
5. Copy each blank worksheet into a mock student project (a folder with a `.Rproj` file whose first line is `Version: 1.0`, plus `analysis/` and `data/` with the data copied in; `here` does not recognise an empty `.Rproj`) in your scratch directory, and confirm it renders unchanged.
6. Do **not** commit or push. The main session commits.
7. Report back in plain language with labelled items: for each deck, what is in it and in the exercise, what you cut from the old deck and why, anything about the data that surprised you, any overlap with other chapters, and decisions you need from the author.
