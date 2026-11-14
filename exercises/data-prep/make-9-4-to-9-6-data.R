# Writes the data for lectures 09-4-1, 09-4-2, 09-5 and exercises 9-4, 9-5, 9-6.
# (Lecture 09-6 and exercise 9-7 use downloads; see make-9-7-downloads.R.)
#
# Lecture files, beside the decks in lectures/Chapter-9-Spatial-Data/:
#   hp_boundary.gpkg     High Plains aquifer outline, 2 polygons, NAD83 lon/lat
#   railroads_ne.gpkg    3,218 railroad segments in Nebraska, NAD83 lon/lat
#   wells_ne.gpkg        1,000 Nebraska irrigation wells as points, with
#                        gw_extracted (groundwater pumped, acre-feet; made up
#                        by the package author), NAD83 lon/lat
#   huc_ia.gpkg          28 hydrologic units (watersheds) covering Iowa
#   ia_nitrogen.gpkg     99 Iowa counties with nitrogen_rate (lb/acre; made up
#                        by the package author)
#   il_ne_corn_yield.rds copied from the old course: the result of a USDA-NASS
#                        Quick Stats download (see lecture 09-6)
# The decks also read ne_counties.gpkg and ne_ppt_2012aug.tif, which
# make-9-1-to-9-3-data.R writes.
#
# Exercise files, in exercises/data/:
#   9-4-co-counties.gpkg, 9-4-hp-boundary.gpkg
#   9-5-corn-yield-points.gpkg, 9-5-treatment-blocks.gpkg,
#   9-5-soy-yield-points.gpkg, 9-5-seed-rate-points.gpkg
#     The soybean files keep the CRS the package records, WGS 84 / UTM zone
#     28N, which places the field in the Atlantic Ocean west of Portugal. The
#     field is in the US, so the recorded CRS is wrong; it is kept on purpose,
#     because noticing it is part of exercise 9-5. Distances inside the field
#     are unaffected (every UTM zone is in metres).
#   9-6-ndre.tif, 9-6-treatment-blocks.gpkg, 9-6-corn-yield-points.gpkg
#   9-6-co-counties.gpkg
#   9-6-ppt-2012aug.tif  PRISM daily precipitation (mm), 1-5 Aug 2012. It is
#                        the Nebraska file of the lectures: it covers 40 to 43
#                        degrees north, so only a strip of northern Colorado.
#                        Exercise 9-6 hands it over as "the file a colleague
#                        used"; finding that it does not cover Colorado is the
#                        point of its last task.
#
# Source: r.spatial.workshop.datasets.
#
# Run from the repo root: Rscript exercises/data-prep/make-9-4-to-9-6-data.R

suppressMessages({
  library(sf)
  library(terra)
  library(stars)
  library(dplyr)
})
data(list = c("hp_boundary", "railroads_ne", "wells_ne_sf", "huc_ia",
              "ia_nitrogen", "co_counties", "corn_yield", "treatment_blocks",
              "soy_yield", "as_applied_s_rate", "NDRE", "prism_2012_aug"),
     package = "r.spatial.workshop.datasets")

lec <- "lectures/Chapter-9-Spatial-Data"
exd <- "exercises/data"
w <- function(x, path) st_write(x, path, delete_dsn = TRUE, quiet = TRUE)

# ---- lecture files --------------------------------------------------------
w(hp_boundary, file.path(lec, "hp_boundary.gpkg"))
w(railroads_ne, file.path(lec, "railroads_ne.gpkg"))
w(select(wells_ne_sf, wellid, gw_extracted), file.path(lec, "wells_ne.gpkg"))
w(huc_ia, file.path(lec, "huc_ia.gpkg"))
w(ia_nitrogen, file.path(lec, "ia_nitrogen.gpkg"))
file.copy("../Data-Science-with-R-Quarto/lectures/Chapter-9-Spatial-Data/Data/il_ne_corn_yield.rds",
          file.path(lec, "il_ne_corn_yield.rds"), overwrite = TRUE)

# ---- exercise 9-4 ---------------------------------------------------------
co <- co_counties |> select(countyfp, name) |> arrange(name)
w(co, file.path(exd, "9-4-co-counties.gpkg"))
w(hp_boundary, file.path(exd, "9-4-hp-boundary.gpkg"))

# ---- exercise 9-5 ---------------------------------------------------------
w(mutate(corn_yield, point_id = row_number(), .before = 1),
  file.path(exd, "9-5-corn-yield-points.gpkg"))
w(mutate(treatment_blocks, block_id = row_number(), .before = 1),
  file.path(exd, "9-5-treatment-blocks.gpkg"))
w(select(soy_yield, yield_id, yield), file.path(exd, "9-5-soy-yield-points.gpkg"))
w(select(as_applied_s_rate, seed_id, seed_rate), file.path(exd, "9-5-seed-rate-points.gpkg"))

# ---- exercise 9-6 ---------------------------------------------------------
writeRaster(rast(NDRE), file.path(exd, "9-6-ndre.tif"), overwrite = TRUE)
w(mutate(treatment_blocks, block_id = row_number(), .before = 1),
  file.path(exd, "9-6-treatment-blocks.gpkg"))
w(mutate(corn_yield, point_id = row_number(), .before = 1),
  file.path(exd, "9-6-corn-yield-points.gpkg"))
w(co, file.path(exd, "9-6-co-counties.gpkg"))
ppt <- rast(prism_2012_aug)
names(ppt) <- paste0("ppt_", format(as.Date(names(ppt)), "%Y_%m_%d"))
writeRaster(ppt, file.path(exd, "9-6-ppt-2012aug.tif"), overwrite = TRUE)

# ---- README files handed out with the data --------------------------------
writeLines(c(
  "Files for exercise 9-4",
  "",
  "9-4-co-counties.gpkg: the counties of Colorado, one row per county.",
  "  Columns: countyfp (county code), name. Longitude and latitude, NAD83",
  "  (EPSG 4269).",
  "",
  "9-4-hp-boundary.gpkg: the outline of the High Plains aquifer, an",
  "  underground water reservoir under parts of eight states. Longitude and",
  "  latitude, NAD83 (EPSG 4269)."
), file.path(exd, "9-4-README.txt"))

writeLines(c(
  "Files for exercise 9-5",
  "",
  "Corn field, a nitrogen trial on a US farm:",
  "  9-5-corn-yield-points.gpkg: one point per yield measurement from the",
  "    combine. Columns: point_id, yield (bushels per acre).",
  "  9-5-treatment-blocks.gpkg: the trial's plots. Columns: block_id,",
  "    product, target_rate (nitrogen applied, lb per acre), replication.",
  "  Both in WGS 84 / UTM zone 15N (EPSG 32615), metres.",
  "",
  "Soybean field, a seeding-rate trial on a US farm:",
  "  9-5-soy-yield-points.gpkg: one point per yield measurement. Columns:",
  "    yield_id, yield (bushels per acre).",
  "  9-5-seed-rate-points.gpkg: one point per seeding-rate record from the",
  "    planter. Columns: seed_id, seed_rate (seeding rate as recorded).",
  "  Coordinates in metres."
), file.path(exd, "9-5-README.txt"))

writeLines(c(
  "Files for exercise 9-6",
  "",
  "Corn field (the nitrogen trial of exercise 9-5):",
  "  9-6-ndre.tif: NDRE, a measure of how green the crop is, from a drone",
  "    image. One layer. Values from about -0.1 to 0.7; higher is greener.",
  "  9-6-corn-yield-points.gpkg: yield points, as in exercise 9-5.",
  "  9-6-treatment-blocks.gpkg: the trial's plots, as in exercise 9-5.",
  "",
  "Colorado:",
  "  9-6-co-counties.gpkg: the counties of Colorado, NAD83 longitude and",
  "    latitude (EPSG 4269).",
  "  9-6-ppt-2012aug.tif: PRISM daily precipitation in millimetres, one",
  "    layer per day, 1 to 5 August 2012, cells about 4 km. A colleague",
  "    used this file in an earlier project and sent it to you."
), file.path(exd, "9-6-README.txt"))
