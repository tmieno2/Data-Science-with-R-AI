# Builds exercises/data/7-1-grain-deliveries.csv for Ex-7-1: an invented
# delivery log of a grain elevator with two weighing sites, harvest 2025
# (1 September to 30 November). Run from the repo root.
#
# What is built into it on purpose (the exercise is about finding these):
# - The North site writes dates month first (09/15/2025); the South site
#   writes them day first (15/09/2025). Nothing in the file says so.
# - Crop names are spelled inconsistently (letter case, "Soy beans"),
#   and the elevator also takes popcorn, which a pattern "corn" also matches.
# - Farm names vary in case and spacing, and one farm appears both as
#   "Schmidt Bros." and "Schmidt Bros".
library(dplyr)
library(readr)

set.seed(7071)
n <- 420

farms <- c("Miller Farms", "Schmidt Bros.", "Hansen Family Farm", "Ortiz Ag",
           "Prairie View LLC", "Kowalski Grain", "Two Rivers Farm", "Lindgren Acres")
popcorn_farms <- c("Hansen Family Farm", "Two Rivers Farm")

d <- tibble(
  true_date = sort(sample(seq(as.Date("2025-09-01"), as.Date("2025-11-30"), by = "day"),
                          n, replace = TRUE)),
  site = sample(c("North", "South"), n, replace = TRUE, prob = c(0.6, 0.4)),
  farm = sample(farms, n, replace = TRUE)
) |>
  mutate(
    ticket = sprintf("T%04d", row_number()),
    crop = case_when(
      farm %in% popcorn_farms & runif(n) < 0.35 ~ "Popcorn",
      runif(n) < 0.55 ~ "Corn",
      TRUE ~ "Soybeans"
    ),
    bushels = round(case_when(
      crop == "Corn" ~ rnorm(n, 1000, 60),
      crop == "Soybeans" ~ rnorm(n, 900, 50),
      TRUE ~ rnorm(n, 750, 40)
    )),
    date = if_else(site == "North", format(true_date, "%m/%d/%Y"),
                   format(true_date, "%d/%m/%Y"))
  )

# Inconsistent spelling, as typed by different scale operators
respell <- function(x, from, to, share) {
  hit <- x == from & runif(length(x)) < share
  x[hit] <- sample(to, sum(hit), replace = TRUE)
  x
}
d <- d |>
  mutate(
    crop = respell(crop, "Corn", c("corn", "CORN"), 0.25),
    crop = respell(crop, "Soybeans", c("soybeans", "Soy beans", "SOYBEANS"), 0.25),
    crop = respell(crop, "Popcorn", c("popcorn"), 0.3),
    farm = respell(farm, "Miller Farms", c("Miller  Farms", "miller farms"), 0.3),
    farm = respell(farm, "Schmidt Bros.", c("Schmidt Bros"), 0.4),
    farm = respell(farm, "Ortiz Ag", c("ORTIZ AG"), 0.3),
    farm = respell(farm, "Prairie View LLC", c("Prairie View  LLC"), 0.2)
  )

write_csv(select(d, ticket, site, date, farm, crop, bushels),
          "exercises/data/7-1-grain-deliveries.csv")
