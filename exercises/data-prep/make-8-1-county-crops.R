# Writes exercises/data/8-1-county-crops.csv, used by exercises 8-1, 8-2 and 8-3.
#
# Source: county_yield from the r.workshop.datasets package (corn and soybean
# yields and drought by county, Colorado, Kansas and Nebraska, 2000 to 2018).
# Kept as a csv so students need no package from a custom repository.
#
# Changes from the source:
#   - county_name added from tidycensus::fips_codes
#   - weeks_severe  = d2_5_9: weeks from May to September in drought category
#     D2 (severe), 1 decimal
#   - weeks_extreme = d3_5_9 + d4_5_9: weeks from May to September in the two
#     worst categories (D3 extreme, D4 exceptional), 1 decimal
#   - the milder categories (D0, D1) dropped
#   - soy_yield kept with its missing values: Colorado has none at all, and
#     many Kansas and Nebraska county-years have none. Exercise 8-2 depends on
#     this, so do not fill or drop them.
#   - sorted by state, county, year
#
# Run from the repo root: Rscript exercises/data-prep/make-8-1-county-crops.R

library(dplyr)

data(county_yield, package = "r.workshop.datasets")

state_codes <- c(Colorado = "08", Kansas = "20", Nebraska = "31")

names_lookup <- tidycensus::fips_codes |>
  filter(state_code %in% state_codes) |>
  transmute(state_code, county_code, county_name = sub(" County$", "", county))

out <- county_yield |>
  mutate(state_code = state_codes[state_name]) |>
  left_join(names_lookup, by = c("state_code", "county_code")) |>
  transmute(
    state_name,
    county_code,
    county_name,
    year,
    corn_yield,
    soy_yield,
    weeks_severe  = round(d2_5_9, 1),
    weeks_extreme = round(d3_5_9 + d4_5_9, 1)
  ) |>
  arrange(state_name, county_name, year)

stopifnot(!anyNA(out$county_name), nrow(out) == nrow(county_yield))

readr::write_csv(out, here::here("exercises", "data", "8-1-county-crops.csv"))
