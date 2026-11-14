# Builds exercises/data/6-1-messy-project.zip, the disorganised folder that
# exercise 6-1 asks students to turn into a project.
#
#   Rscript exercises/data-prep/make-6-1-messy-project.R    (from the repo root)
#
# The folder imitates a project that grew without a plan:
#   corn_yields.csv         the file as downloaded (the 03-1 corn data)
#   corn_yields_fixed.csv   the same file after someone deleted rows by hand;
#                           nothing records which rows or why. The deleted rows
#                           are the non-irrigated counties with a yield below
#                           132, which raises the non-irrigated average.
#   corn_clean.csv          written by analysis_final.R
#   yield_by_irrigation.png written by analysis_final.R
#   analysis_final.R        one script doing everything, with setwd()
#   analysis_final_v2.R     a near copy that uses an object it never creates
#   notes.txt               a note that says nothing about the deleted rows

library(readr)
library(dplyr)
library(ggplot2)

src <- "lectures/Chapter-3-DataWrangling/corn_yields.csv"
out_zip <- "exercises/data/6-1-messy-project.zip"

work <- file.path(tempdir(), "build-6-1")
unlink(work, recursive = TRUE)
dir <- file.path(work, "corn-messy")
dir.create(dir, recursive = TRUE)

file.copy(src, file.path(dir, "corn_yields.csv"))
corn <- read_csv(src, show_col_types = FALSE, col_types = cols(FIPS = "c"))

fixed <- filter(corn, !(Irrigated == 0 & Yield < 132))
write_csv(fixed, file.path(dir, "corn_yields_fixed.csv"))

clean <- select(fixed, FIPS, County_name, Irrigated, Yield)
write_csv(clean, file.path(dir, "corn_clean.csv"))

p <- ggplot(clean, aes(x = factor(Irrigated), y = Yield)) +
  geom_boxplot() +
  labs(x = "Irrigated", y = "Yield (bu/ac)")
ggsave(file.path(dir, "yield_by_irrigation.png"), p, width = 5, height = 4, dpi = 100)

writeLines(c(
  'setwd("C:/Users/jan/Desktop/corn")',
  "library(tidyverse)",
  "",
  'corn <- read_csv("corn_yields_fixed.csv")',
  "corn <- select(corn, FIPS, County_name, Irrigated, Yield)",
  'write_csv(corn, "corn_clean.csv")',
  "",
  "corn %>% group_by(Irrigated) %>% summarise(mean_yield = mean(Yield))",
  "",
  "ggplot(corn, aes(x = factor(Irrigated), y = Yield)) + geom_boxplot()",
  'ggsave("yield_by_irrigation.png")'
), file.path(dir, "analysis_final.R"))

writeLines(c(
  'setwd("C:/Users/jan/Desktop/corn")',
  "library(tidyverse)",
  "",
  "corn <- filter(corn, Yield > 120)",
  "model <- lm(Yield ~ Irrigated, data = corn)",
  "summary(model)",
  'write_csv(corn, "corn_yields.csv")'
), file.path(dir, "analysis_final_v2.R"))

writeLines(c(
  "corn project, Jan",
  "- data from NASS quick stats, 2008, Nebraska counties",
  "- fixed the data",
  "- v2 is the newer one?"
), file.path(dir, "notes.txt"))

dir.create(dirname(out_zip), showWarnings = FALSE)
unlink(out_zip)
zip::zip(file.path(getwd(), out_zip), "corn-messy", root = work)
cat("wrote", out_zip, "\n")
