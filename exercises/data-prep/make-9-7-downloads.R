# Downloads the data for lecture 09-7 (getting spatial data, file L06_get_spatial_data.qmd) and the answer
# data for exercise 9-7. Needs an internet connection. First run: 2026-11-14.
#
# Lecture files, beside the decks in lectures/Chapter-9-Spatial-Data/:
#   tigris_ne_counties.gpkg   Nebraska counties from the Census Bureau via
#                             tigris, generalised (cb = TRUE), 2022 boundaries
#   tigris_ct_counties_2021.gpkg, tigris_ct_counties_2022.gpkg
#                             Connecticut, to show that boundaries change by
#                             year (2022 replaced its 8 counties with 9
#                             planning regions)
#   PRISM-ppt/                three daily PRISM precipitation downloads, 1-3
#                             June 2023, as prism::get_prism_dailys() saved
#                             them (one folder per day), except that the
#                             station files (.stn.csv), which the lecture
#                             does not use, are deleted
#
# Exercise 9-7 answer data, in exercises/data/ (read by the page's hidden
# answers chunk; students download their own copies):
#   9-7-states-table.csv      the attribute table of tigris::states(cb = TRUE)
#   9-7-ks-counties.gpkg      Kansas counties, cb = TRUE, 2022
#   9-7-ppt-kansas.tif        PRISM daily precipitation, 10-14 July 2023,
#                             cropped to Kansas with snap = "out", so it holds
#                             every cell any crop of Kansas could need. Also
#                             published on the exercise page as the fallback
#                             for students whose PRISM download is refused.
#                             The answers chunk crops it again with the
#                             default snap, as students will.
#   9-7-nass-soy-items.csv    the NASS data items containing SOYBEANS, ACRES
#                             and HARVESTED, from tidyUSDA::allDataItem (a
#                             list shipped with tidyUSDA, which is no longer
#                             on CRAN; install from GitHub to rerun this
#                             part). The page uses rnassqs, which needs a key
#                             to list items.
#
# Not downloaded: USDA-NASS Quick Stats needs an API key, and none was
# available. Lecture 09-7 uses il_ne_corn_yield.rds, a download saved by the
# old course (see make-9-4-to-9-6-data.R). CropScape (CDL) timed out on
# 2026-11-14, so the lecture shows CDL code without running it.
#
# Run from the repo root: Rscript exercises/data-prep/make-9-7-downloads.R

suppressMessages({
  library(sf)
  library(terra)
  library(dplyr)
})
options(tigris_use_cache = FALSE)
lec <- "lectures/Chapter-9-Spatial-Data"
exd <- "exercises/data"
w <- function(x, path) st_write(x, path, delete_dsn = TRUE, quiet = TRUE)

# ---- lecture --------------------------------------------------------------
ne <- tigris::counties(state = "NE", cb = TRUE, year = 2022, progress_bar = FALSE)
w(ne, file.path(lec, "tigris_ne_counties.gpkg"))

for (yr in c(2021, 2022)) {
  ct <- tigris::counties(state = "CT", cb = TRUE, year = yr, progress_bar = FALSE)
  w(ct, file.path(lec, paste0("tigris_ct_counties_", yr, ".gpkg")))
}

prism_dir <- file.path(lec, "PRISM-ppt")
dir.create(prism_dir, showWarnings = FALSE)
prism::prism_set_dl_dir(prism_dir)
prism::get_prism_dailys(type = "ppt", minDate = "2023-06-01",
                        maxDate = "2023-06-03", keepZip = FALSE)
file.remove(list.files(prism_dir, pattern = "[.]stn[.]csv$", recursive = TRUE, full.names = TRUE))

# ---- exercise 9-7 answers -------------------------------------------------
st <- tigris::states(cb = TRUE, year = 2022, progress_bar = FALSE)
readr::write_csv(st_drop_geometry(st), file.path(exd, "9-7-states-table.csv"))

ks <- tigris::counties(state = "KS", cb = TRUE, year = 2022, progress_bar = FALSE)
w(ks, file.path(exd, "9-7-ks-counties.gpkg"))

tmp <- file.path(tempdir(), "prism-ks")
dir.create(tmp, showWarnings = FALSE)
prism::prism_set_dl_dir(tmp)
prism::get_prism_dailys(type = "ppt", minDate = "2023-07-10",
                        maxDate = "2023-07-14", keepZip = FALSE)
bil <- list.files(tmp, pattern = "[.]bil$", recursive = TRUE, full.names = TRUE)
ppt <- rast(bil)
ppt_ks <- crop(ppt, vect(st_transform(ks, crs(ppt))), snap = "out")
writeRaster(ppt_ks, file.path(exd, "9-7-ppt-kansas.tif"), overwrite = TRUE)

items <- tidyUSDA::allDataItem
items <- unname(items[grepl("SOYBEANS", items) & grepl("ACRES", items) & grepl("HARVESTED", items)])
readr::write_csv(tibble::tibble(short_desc = items), file.path(exd, "9-7-nass-soy-items.csv"))
