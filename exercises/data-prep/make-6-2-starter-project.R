# Builds exercises/data/6-2-starter-project.zip, the small project that
# exercise 6-2 puts under version control.
#
#   Rscript exercises/data-prep/make-6-2-starter-project.R    (from the repo root)
#
# The project is organised as in lecture 06-1, and holds the kinds of files a
# real project accumulates that must not all be committed:
#   ch6-git.Rproj, README.md               written by the student: track
#   analysis/01-clean.qmd, 02-summary.qmd  the steps: track
#   data/raw/corn_yields.csv               small public data: track
#   analysis/01-clean.html, 01-clean_files/  rendered output: ignore
#   data/processed/corn_clean.rds          made by 01-clean.qmd: ignore
#   .Renviron                              holds a (fake) API key: never commit
#   .Rhistory                              written by RStudio: ignore

src <- "lectures/Chapter-3-DataWrangling/corn_yields.csv"
out_zip <- "exercises/data/6-2-starter-project.zip"

work <- file.path(tempdir(), "build-6-2")
unlink(work, recursive = TRUE)
proj <- file.path(work, "ch6-git")
for (d in c("analysis", "data/raw", "data/processed")) {
  dir.create(file.path(proj, d), recursive = TRUE)
}

writeLines(c(
  "Version: 1.0", "",
  "RestoreWorkspace: No", "SaveWorkspace: No", "AlwaysSaveHistory: Default", "",
  "EnableCodeIndexing: Yes", "UseSpacesForTab: Yes", "NumSpacesForTab: 2",
  "Encoding: UTF-8", "", "RnwWeave: Sweave", "LaTeX: pdfLaTeX"
), file.path(proj, "ch6-git.Rproj"))

writeLines(c(
  "# Corn yields and irrigation",
  "",
  "Corn yields of irrigated and non-irrigated fields in Nebraska counties, 2008."
), file.path(proj, "README.md"))

file.copy(src, file.path(proj, "data", "raw", "corn_yields.csv"))

writeLines(c(
  "---", "title: \"Clean the corn data\"", "---", "",
  "Read the raw yields, keeping FIPS as text so codes keep their leading zeros.", "",
  "```{r}",
  "corn <- readr::read_csv(",
  "  here::here(\"data\", \"raw\", \"corn_yields.csv\"),",
  "  col_types = readr::cols(FIPS = \"c\")",
  ")",
  "```", "",
  "Drop fields with a yield at or below the cutoff.", "",
  "```{r}",
  "corn <- dplyr::filter(corn, Yield > 0)",
  "```", "",
  "Save the cleaned table for the next step.", "",
  "```{r}",
  "saveRDS(corn, here::here(\"data\", \"processed\", \"corn_clean.rds\"))",
  "cat(\"rows kept:\", nrow(corn), \"\\n\")",
  "```"
), file.path(proj, "analysis", "01-clean.qmd"))

writeLines(c(
  "---", "title: \"Average yield by irrigation\"", "---", "",
  "Read the cleaned table that step 01 saved.", "",
  "```{r}",
  "corn <- readRDS(here::here(\"data\", \"processed\", \"corn_clean.rds\"))",
  "```", "",
  "Average yield for irrigated (1) and non-irrigated (0) fields.", "",
  "```{r}",
  "tapply(corn$Yield, corn$Irrigated, mean)",
  "```"
), file.path(proj, "analysis", "02-summary.qmd"))

# Render step 01 so the folder holds rendered output and a processed file,
# as a project in use does.
status <- system2("quarto", c("render", shQuote(file.path(proj, "analysis", "01-clean.qmd")), "--quiet"))
stopifnot(status == 0)

writeLines("NASS_API_KEY=practice-key-not-real-0000", file.path(proj, ".Renviron"))
writeLines(c("library(here)", "here()", "list.files(here(\"data\", \"raw\"))"), file.path(proj, ".Rhistory"))

unlink(out_zip)
zip::zip(file.path(getwd(), out_zip), "ch6-git", root = work, include_directories = TRUE)
cat("wrote", out_zip, "\n")
