# Reviewing a redesigned deck: the reviewer's brief

Review redesigned lecture decks for a university Data Science with R course, and judge whether they serve the course's new objectives. Report findings only; do not edit any file.

## Read these

1. `~/Teaching/Data-Science-with-R-AI/.claude/prompts/redesign-deck-common.md`: the brief the author of the decks worked from, including the objectives, the rules learned from reviewing the model deck, and the writing rules. Judge against it.
2. The model deck that has already been through review: `~/Teaching/Data-Science-with-R-AI/lectures/Chapter-3-DataWrangling/03-1-input-output.qmd`.
3. The decks under review, in full, plus their exercise pages and worksheets (named in your prompt), and the rendered HTML under `~/Teaching/Data-Science-with-R-AI/docs/` (large; search it for specific outputs rather than reading it whole).
4. The old versions of the decks in `~/Teaching/Data-Science-with-R-Quarto/lectures/`, to spot anything important that was dropped.

## What to judge

A. Does each slide serve the objectives (concept, reading code through its general pattern, asking AI, checking)? Flag any slide that slips back into syntax teaching, and any objective a student would leave without.
B. Can a student studying alone, before class, follow it? Missing steps, terms used before they are defined, ordering problems, references to the exercise.
C. Is every claim about what code does true? Check against the rendered output; if a claim is not shown there, run R (`Rscript -e ...`) to test it.
D. Consistency: the closing instructions identical to 03-1's "Closing instructions" tab wherever a request asks for code; blanks never filled in and described in words; one name per thing.
E. Does the deck give away the exercise's main discovery? Are the exercise's answer-box numbers right, and does the worksheet render for a student?
F. Length and redundancy.
G. The writing rules: plain literal language, terms defined where first used, no em-dashes, no two visible code blocks back to back, no tab holding only a side point, ggplot2 only.

## Report

A numbered list of findings, most important first. For each: the file, slide title (and tab), what is wrong, why it matters, and a concrete fix (exact replacement wording where it is wording). Mark each Must fix, Should fix, or Optional. Leave out praise. Mark anything you are unsure of as uncertain. Plain language, no em-dashes.
