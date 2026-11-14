Redesign the first data visualization lecture for my Data Science course, in the same spirit as the data import/export lecture that has already been redesigned.

## Background

I am overhauling my Data Science with R course (AECN 896-05) for 2027 and teaching it as a flipped course: students study the lecture deck before class and work on an exercise in class. AI now writes most code, so the course teaches:

1. **The concept**: what the step is, and what has to be true for it to succeed.
2. **Reading code**: enough to recognise what a line does, not to write it from memory.
3. **Asking AI**: what the AI cannot know (what the data contains, what fact or idea a figure must convey, and to whom) and so must be told.
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

1. `lectures/Chapter-4-Data-Visualization/04-1-data-visualization-basics.qmd`, a rewritten deck. Keep the parts 03-1 has (How this lecture works, Asking AI, Recommended requests, Summary), but order and name the middle sections to suit a deck about communication.
2. `exercises/4-1-data-visualization-basics.qmd`, the exercise web page: setup, download links, and collapsed answer boxes whose numbers are computed from the data at render time.
3. `exercises/worksheets/ex-4-1.qmd`, the fill-in worksheet, where every task runs Look, Predict, Ask (from a recommended request with `<...>` blanks), Render and read the HTML.
4. Any data file the exercise needs, plus the short script that made it if you construct one.

## The content I want in the deck

**For this chapter, the subject is communication, not code.** A figure exists to convey one fact or idea to a reader. What students must learn is how to choose the design that conveys it best, and how to judge whether a figure does. The AI can produce any figure in seconds; it cannot know what the student is trying to say or who the reader is. Code appears only as a sample to recognise, and only where it helps a student read what the AI wrote.

Candidates (use your judgement after reading the old deck, which is mostly about code and needs reshaping, not trimming):

1. **Start from the message.** Before any figure, write the one sentence the reader should take away, and who the reader is. Every design decision below is judged against that sentence.
2. **Choosing the type of figure** from the kind of message: a distribution, a relationship between two variables, a comparison across groups, a change over time, a part of a whole. Show the same data drawn two or three ways, and which one makes a given message obvious and which hides it.
3. **Colour.** When colour should carry information at all; colour for categories (distinct hues) versus for amounts (one hue from light to dark) versus for a value above or below a midpoint (two hues diverging from a neutral middle); highlighting the one group the message is about and greying out the rest; keeping the same colour for the same thing across figures; palettes readable by colour-blind readers; not using more colours than a reader can tell apart.
4. **Other design choices that decide whether the message lands:** ordering categories by value rather than alphabetically; one panel versus several small panels with shared axes; axis ranges (bars must start at zero; for points and lines, the range should show the variation that matters); axis titles with units; a title that states the finding rather than naming the variables; labelling lines or points directly instead of making the reader look up a legend; removing what does not serve the message.
5. **A figure must be correct before it can communicate.** Keep this short: one slide on what must be true of the data (one row per thing drawn, the right type per column, so that a category stored as a number does not get a colour gradient), with one or two silent failures shown with real output, and the check of asking the AI to print the data the figure is built from next to the figure in the HTML.
6. **Judging a figure by reading the HTML.** A short checklist the student applies to any figure, theirs or the AI's, written as questions with a clear yes or no: can someone who has not seen the data state the message within a few seconds? Does the colour carry information, or is it decoration? Would the message survive printing in black and white? Is anything there that the message does not need?
7. **Using AI for design.** The AI makes alternatives cheaply, so the skill is choosing among them. A central request type: give the AI the message and the reader, ask for two or three different designs rendered side by side in the HTML, each with one sentence on what it makes easy to see; the student picks one and writes why. Other requests, each with `<...>` blanks for what only the student knows (the message, the reader, which group matters): improving a given figure for a stated message; critiquing a figure against the checklist; and checking that a figure matches its data. Each request ends with the closing instructions **copied word for word** from the "Closing instructions" tab of the 03-1 deck.

For the exercise, favour tasks where students state a message, ask for alternatives, choose, and justify the choice in writing, and tasks where they critique and improve a weak figure, over tasks that only produce a figure. Answer boxes for design questions should explain which choice serves the stated message and why, not claim a single right answer where several would do.

## Rules (from me, for everything you write)

1. Plain language: write as for a smart person who has not seen the code. Use a technical term only when the student needs it, and define it in parentheses where it first appears. Literal and exact, never metaphorical: no invented nicknames or images for mechanisms. One name per thing, used consistently.
2. No em-dashes anywhere. Use a comma, a semicolon, or a new sentence.
3. Every figure is ggplot2. Never base R plotting. Palettes must be readable by colour-blind readers unless a slide is deliberately showing a bad example, and then it must say so.
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
