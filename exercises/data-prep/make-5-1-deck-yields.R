# Writes three files beside lecture 05-1, one per year:
#   lectures/Chapter-5-function-loop-parallel/yields_2016.csv
#   lectures/Chapter-5-function-loop-parallel/yields_2017.csv
#   lectures/Chapter-5-function-loop-parallel/yields_2018.csv
#
# Source: exercises/data/county_yield.csv, Nebraska rows only. Each file holds
# county_name and corn_yield (bu/acre) for one year. The year column is
# dropped on purpose: the year is only in the file name, so the deck can show
# why a loop has to record which input each result came from.
#
# Run from the repo root: Rscript exercises/data-prep/make-5-1-deck-yields.R

library(dplyr)

d <- readr::read_csv(here::here("exercises", "data", "county_yield.csv"), show_col_types = FALSE)

for (yr in 2016:2018) {
  out <- d |>
    filter(state_name == "Nebraska", year == yr) |>
    select(county_name, corn_yield)
  readr::write_csv(
    out,
    here::here("lectures", "Chapter-5-function-loop-parallel", paste0("yields_", yr, ".csv"))
  )
}
