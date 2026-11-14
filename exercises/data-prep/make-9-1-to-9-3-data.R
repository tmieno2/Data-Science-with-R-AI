# Writes the data for lectures 09-1, 09-2, 09-3 and exercises 9-1, 9-2, 9-3.
#
# Lecture files, beside the decks in lectures/Chapter-9-Spatial-Data/:
#   ne_counties.gpkg      93 Nebraska counties, NAD83 longitude/latitude
#   wells_ne.csv          1,000 irrigation wells: wellid, longdd, latdd
#   ne_corn_acres.gpkg    corn harvested acres by county and year, 2020-2023
#   ne_ppt_2012aug.tif    PRISM daily precipitation (mm), Nebraska, 1-5 Aug 2012
#   ne_ppt_raw.tif        1 Aug 2012 of the above, stored as whole numbers in
#                         hundredths of a mm, with -9999 for cells outside the
#                         state, and no no-data value declared in the file
#
# Exercise files, in exercises/data/:
#   9-1-co-counties.shp/.shx/.dbf   64 Colorado counties, NAD83 lon/lat, with
#                                   the .prj deliberately left out
#   9-1-stations.csv                40 made-up station locations inside
#                                   Colorado, in NAD83 / UTM zone 13N metres
#   9-1-README.txt                  what the files hold, including the CRS
#   9-2-tmax-colorado.tif           PRISM daily maximum temperature, Colorado,
#                                   1-3 June 2023, projected to EPSG 5070,
#                                   whole numbers in tenths of a degree C,
#                                   -9999 outside the state, no-data value not
#                                   declared
#   9-2-co-counties.gpkg            64 Colorado counties, NAD83 lon/lat
#   9-2-README.txt
#   9-3-ne-counties.gpkg            93 Nebraska counties, NAD83 lon/lat
#   9-3-ne-corn-yield.csv           corn yield by county, 2000-2006 (only the
#                                   counties and years the source reports)
#
# Sources: r.spatial.workshop.datasets (counties, wells, corn acres, PRISM
# precipitation, county_yield), and the PRISM tmax .bil files under
# ../Data-Science-with-R-Quarto/lectures/Chapter-9-Spatial-Data/Data/PRISM/tmax.
#
# Run from the repo root: Rscript exercises/data-prep/make-9-1-to-9-3-data.R

suppressMessages({
  library(sf)
  library(terra)
  library(stars)
  library(dplyr)
  library(readr)
})
data(list = c("ne_counties", "wells_ne", "corn_acres_ne", "prism_2012_aug",
              "co_counties", "county_yield"),
     package = "r.spatial.workshop.datasets")

# Writes a raster whose -9999 cells are ordinary values: no no-data value in
# the file, and statistics computed over every cell. terra alone writes a
# "nan" no-data tag and statistics that skip -9999, so the file goes through
# gdal_translate once more.
write_undeclared <- function(x, path) {
  tmp <- tempfile(fileext = ".tif")
  writeRaster(x, tmp, datatype = "INT2S", overwrite = TRUE)
  unlink(c(path, paste0(path, ".aux.xml")))
  gdal_utils("translate", tmp, path,
             options = c("-a_nodata", "none", "-stats", "-co", "COMPRESS=DEFLATE"))
}

lec <- "lectures/Chapter-9-Spatial-Data"
exd <- "exercises/data"
dir.create(lec, showWarnings = FALSE)

# ---- lecture files --------------------------------------------------------
ne <- ne_counties |>
  select(countyfp, name) |>
  arrange(name)
st_write(ne, file.path(lec, "ne_counties.gpkg"), delete_dsn = TRUE, quiet = TRUE)

write_csv(as.data.frame(wells_ne), file.path(lec, "wells_ne.csv"))

st_write(corn_acres_ne |> arrange(year, county_code),
         file.path(lec, "ne_corn_acres.gpkg"), delete_dsn = TRUE, quiet = TRUE)

ppt <- rast(prism_2012_aug)
names(ppt) <- paste0("ppt_", format(as.Date(names(ppt)), "%Y_%m_%d"))
writeRaster(ppt, file.path(lec, "ne_ppt_2012aug.tif"), overwrite = TRUE)

raw <- round(ppt[[1]] * 100)
raw[is.na(raw)] <- -9999
names(raw) <- "ppt"
write_undeclared(raw, file.path(lec, "ne_ppt_raw.tif"))

# ---- exercise 9-1 ---------------------------------------------------------
co <- co_counties |> select(countyfp, name) |> arrange(name)
shp <- file.path(exd, "9-1-co-counties.shp")
st_write(co, shp, delete_dsn = TRUE, quiet = TRUE)
file.remove(sub("\\.shp$", ".prj", shp))
unlink(sub("\\.shp$", ".cpg", shp))

set.seed(91)
co_utm <- st_transform(st_union(co), 26913)
stations <- st_sample(co_utm, 40)
xy <- round(st_coordinates(stations))
write_csv(
  tibble(station_id = sprintf("CO-%03d", 1:40), easting = xy[, 1], northing = xy[, 2]),
  file.path(exd, "9-1-stations.csv")
)

writeLines(c(
  "Files for exercise 9-1",
  "",
  "9-1-co-counties.shp, with 9-1-co-counties.shx and 9-1-co-counties.dbf:",
  "  the counties of Colorado, one row per county. Columns: countyfp (county",
  "  code), name. Coordinates are longitude and latitude in NAD83 (EPSG 4269).",
  "  The .prj file was lost when the files were emailed.",
  "",
  "9-1-stations.csv: weather stations, one row per station. Columns:",
  "  station_id, easting, northing. easting and northing are metres in",
  "  NAD83 / UTM zone 13N (EPSG 26913)."
), file.path(exd, "9-1-README.txt"))

# ---- exercise 9-2 ---------------------------------------------------------
tdir <- "../Data-Science-with-R-Quarto/lectures/Chapter-9-Spatial-Data/Data/PRISM/tmax"
days <- c("20230601", "20230602", "20230603")
tmax <- rast(file.path(tdir, paste0("PRISM_tmax_stable_4kmD2_", days, "_bil"),
                       paste0("PRISM_tmax_stable_4kmD2_", days, "_bil.bil")))
co_v <- vect(st_transform(co, crs(tmax)))
tmax <- mask(crop(tmax, co_v, snap = "out"), co_v)
tmax <- project(tmax, "EPSG:5070", res = 4000, method = "bilinear")
tmax <- mask(tmax, project(co_v, "EPSG:5070"))
tmax <- round(tmax * 10)
tmax[is.na(tmax)] <- -9999
names(tmax) <- paste0("tmax_", c("2023_06_01", "2023_06_02", "2023_06_03"))
write_undeclared(tmax, file.path(exd, "9-2-tmax-colorado.tif"))

st_write(co, file.path(exd, "9-2-co-counties.gpkg"), delete_dsn = TRUE, quiet = TRUE)

writeLines(c(
  "Files for exercise 9-2",
  "",
  "9-2-tmax-colorado.tif: daily maximum air temperature in Colorado from",
  "  PRISM, one layer per day, 1, 2 and 3 June 2023. Cells are 4 km by 4 km.",
  "  Values are whole numbers in tenths of a degree Celsius (215 means",
  "  21.5 C). Cells outside Colorado hold -9999, which means no data.",
  "  CRS: NAD83 / Conus Albers (EPSG 5070), in metres.",
  "",
  "9-2-co-counties.gpkg: the counties of Colorado, longitude and latitude",
  "  in NAD83 (EPSG 4269)."
), file.path(exd, "9-2-README.txt"))

# ---- exercise 9-3 ---------------------------------------------------------
st_write(ne, file.path(exd, "9-3-ne-counties.gpkg"), delete_dsn = TRUE, quiet = TRUE)

county_yield |>
  st_drop_geometry() |>
  filter(state_name == "Nebraska", year %in% 2000:2006) |>
  left_join(st_drop_geometry(ne), by = c("county_code" = "countyfp")) |>
  transmute(county_code, county_name = name, year, corn_yield) |>
  arrange(county_name, year) |>
  write_csv(file.path(exd, "9-3-ne-corn-yield.csv"))
