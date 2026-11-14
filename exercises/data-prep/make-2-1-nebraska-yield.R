# Writes exercises/data/2-1-nebraska-yield.csv, for exercises 2-1 and 2-2.
#
# Source: exercises/data/county_yield.csv (see make-county-yield.R), cut to
# Nebraska, 2014 to 2018, and to three columns. The years avoid 2012 so that
# nothing here previews the drought question in exercise 4-1.
#
# Run from the repo root: Rscript exercises/data-prep/make-2-1-nebraska-yield.R

library(dplyr)

out <- readr::read_csv(
  here::here("exercises", "data", "county_yield.csv"),
  col_types = readr::cols(county_code = "c")
) |>
  filter(state_name == "Nebraska", year >= 2014) |>
  transmute(county_code, county_name, year, corn_yield) |>
  arrange(county_name, year)

stopifnot(!anyNA(out), all(nchar(out$county_code) == 3))

readr::write_csv(out, here::here("exercises", "data", "2-1-nebraska-yield.csv"))
