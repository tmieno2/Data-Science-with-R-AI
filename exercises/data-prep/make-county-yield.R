# Writes exercises/data/county_yield.csv, the data for lecture 04-1 and
# exercise 4-1.
#
# Source: county_yield from the r.workshop.datasets package (corn yields and
# drought by county, Colorado, Kansas and Nebraska, 2000 to 2018). Kept as a
# csv so students need no package from a custom repository.
#
# Changes from the source:
#   - county_name added from tidycensus::fips_codes
#   - drought_weeks = d3_5_9 + d4_5_9: weeks from May to September in the two
#     worst drought categories (D3 extreme, D4 exceptional), 1 decimal
#   - soybean yield and the milder drought categories dropped
#   - sorted by state, county, year
#
# Run from the repo root: Rscript exercises/data-prep/make-county-yield.R

library(dplyr)

data(county_yield, package = "r.workshop.datasets")

state_codes <- c(Colorado = "08", Kansas = "20", Nebraska = "31")

names_lookup <- tidycensus::fips_codes |>
  filter(state_code %in% state_codes) |>
  transmute(
    state_code,
    county_code,
    county_name = sub(" County$", "", county)
  )

out <- county_yield |>
  mutate(state_code = state_codes[state_name]) |>
  left_join(names_lookup, by = c("state_code", "county_code")) |>
  transmute(
    state_name,
    county_code,
    county_name,
    year,
    corn_yield,
    drought_weeks = round(d3_5_9 + d4_5_9, 1)
  ) |>
  arrange(state_name, county_name, year)

stopifnot(!anyNA(out$county_name), nrow(out) == nrow(county_yield))

readr::write_csv(out, here::here("exercises", "data", "county_yield.csv"))
