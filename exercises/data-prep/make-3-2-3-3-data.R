# Builds the data files for exercises 3-2 and 3-3:
#   exercises/data/3-2-county_crops.csv    Ex-3-2 (core operations)
#   exercises/data/3-3-corn_yield_wide.csv Ex-3-3 (reshape, then merge)
#   exercises/data/3-3-drought.csv         Ex-3-3 (merge)
#
# Source: county_yield from the r.workshop.datasets package (corn and soybean
# yields and US Drought Monitor weeks by county, Colorado, Kansas and
# Nebraska, 2000 to 2018), with county names from tidycensus::fips_codes.
# Soybean yields are missing in the source for every Colorado row and for
# most Kansas rows; that is left as it is, on purpose (Ex-3-2).
#
# weeks_severe_drought = weeks from May to September (23 in all) in the three
# worst Drought Monitor categories (D2 severe, D3 extreme, D4 exceptional),
# 1 decimal.
#
# One deliberate flaw, for Ex-3-3: every Kansas row for 2016 appears twice in
# 3-3-drought.csv, as exact copies, as if the file had been put together from
# two downloads that overlapped by one year. The exercise page says the file
# is a teaching dataset.
#
# Run from the repo root: Rscript exercises/data-prep/make-3-2-3-3-data.R

library(dplyr)
library(tidyr)

data(county_yield, package = "r.workshop.datasets")

state_codes <- c(Colorado = "08", Kansas = "20", Nebraska = "31")

names_lookup <- tidycensus::fips_codes |>
  filter(state_code %in% state_codes) |>
  transmute(state_code, county_code, county_name = sub(" County$", "", county))

base <- county_yield |>
  mutate(state_code = state_codes[state_name]) |>
  left_join(names_lookup, by = c("state_code", "county_code")) |>
  mutate(weeks_severe_drought = round(d2_5_9 + d3_5_9 + d4_5_9, 1))

stopifnot(!anyNA(base$county_name), nrow(base) == nrow(county_yield))

# Ex-3-2: one row per county and year, long.
crops <- base |>
  transmute(state_name, county_code, county_name, year,
            corn_yield, soy_yield, weeks_severe_drought) |>
  arrange(state_name, county_name, year)
readr::write_csv(crops, here::here("exercises", "data", "3-2-county_crops.csv"), na = "")

# Ex-3-3: corn yields 2014 to 2018, one row per county, one column per year.
recent <- base |> filter(year >= 2014)
wide <- recent |>
  select(state_name, county_code, county_name, year, corn_yield) |>
  arrange(year) |>
  pivot_wider(names_from = year, values_from = corn_yield, names_prefix = "yield_") |>
  arrange(state_name, county_name)
readr::write_csv(wide, here::here("exercises", "data", "3-3-corn_yield_wide.csv"), na = "")

# Ex-3-3: drought weeks, one row per county and year, identified by the
# 5-digit county code (state code followed by county code).
drought <- recent |>
  transmute(fips = paste0(state_code, county_code), year, weeks_severe_drought) |>
  arrange(fips, year)
dup <- drought |> filter(substr(fips, 1, 2) == "20", year == 2016)
drought <- bind_rows(drought, dup) |> arrange(fips, year)
readr::write_csv(drought, here::here("exercises", "data", "3-3-drought.csv"))
