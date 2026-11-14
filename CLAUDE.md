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
