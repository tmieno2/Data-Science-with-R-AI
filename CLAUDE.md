# CLAUDE.md

Redesign of the Data Science course (AECN 896-05), for the year starting 2027.
The previous version is `../Data-Science-with-R-Quarto/`; decks here are rewritten
from it, not copied.

## The teaching approach

AI writes the code, so each deck teaches:

1. **The concept**: what the step is and what has to be true for it to succeed.
2. **Reading code**: enough to recognise what a line does, not to write it from memory.
3. **Asking AI**: what the AI cannot know (where files are, what is inside them,
   what the result is for) and so must be told.
4. **Checking**: concrete checks whose correct answer the student knows in advance.

Function names and arguments appear as samples to recognise, never as the
subject of a slide.

**The core principle of the course: work lives in a `.qmd`, and is judged by
reading the rendered HTML.** The AI writes code into the student's `.qmd`,
with one plain-English sentence above each chunk; the student renders and
assesses the HTML, not the chat. Every recommended request ends with the same
"closing instructions" (which `.qmd` and heading, a sentence above each chunk,
`here::here()` paths, checks printed as "expected X, got Y", render to HTML).
The canonical wording is the "Closing instructions" tab of the "Recommended
requests" slide in `lectures/Chapter-3-DataWrangling/03-1-input-output.qmd`;
reuse it word for word in later decks.

Recommended requests carry `<...>` blanks for what only the student can know
from looking at the data. Never fill them in for the student in a lecture.

## Exercises

In-class (flipped course). Each has two files:

- `exercises/N-N-topic.qmd`: the web page, with setup, download links, and
  collapsed answer boxes whose numbers are computed from the data at render.
- `exercises/worksheets/ex-N-N.qmd`: the fill-in worksheet students download.
  Excluded from the render and published as a resource by the web page. Task
  wording lives only here, so it cannot drift from the page.

## Styling

Lecture styling comes from `../_lecture-shared/`, copied into `lectures/` by
`../sync-lecture-shared.sh`. Do not edit the copies. This repo only uses plain
`{r}` chunks so far, no WebR, so `_extensions/` is absent.

## Rendering

```bash
quarto render > /tmp/render.log 2>&1; echo "EXIT: $?"
```

Never pipe `quarto render`; see trap 5 in `../Data-Science-with-R-Quarto/CLAUDE.md`,
whose other traps apply here too.
