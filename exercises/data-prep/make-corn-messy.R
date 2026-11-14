# Builds exercises/data/corn_messy.csv for Ex-3-1 from the 2008 non-irrigated
# Nebraska rows of corn_yields.csv, plus five invented Colorado rows so that
# some county codes start with 0. Run from the repo root.
library(readr)
library(dplyr)

ne <- read_csv("lectures/Chapter-3-DataWrangling/corn_yields.csv", show_col_types = FALSE) |>
  filter(Irrigated == 0) |>
  transmute(year = Year, state = "NE", county_fips = sprintf("%05d", FIPS),
            county = County_name, yield = as.character(Yield))

co <- tibble(year = 2008, state = "CO",
             county_fips = c("08125", "08063", "08075", "08121", "08087"),
             county = c("YUMA", "KIT CARSON", "LOGAN", "WASHINGTON", "MORGAN"),
             yield = c("140", "118", "135", "102", "160"))

d <- bind_rows(ne, co)
d$yield[c(10, 40, 70)] <- "-999"
d$yield[c(25, 55)] <- "."
names(d)[5] <- "Yield (bu/ac)"

out <- "exercises/data/corn_messy.csv"
writeLines(c(
  "Corn grain yield, non-irrigated, 2008. Teaching dataset built from USDA NASS county estimates; Colorado rows are invented.",
  "Missing values: -999 = withheld to avoid disclosing individual operations, . = not reported"
), out)
write_csv(d, out, append = TRUE, col_names = TRUE, na = "")
