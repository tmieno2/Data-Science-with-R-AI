# Builds exercises/data/5-1-nitrogen-trials.zip for Ex-5-1: a folder
# nitrogen-trials/ with one csv per field, field_01.csv to field_12.csv.
#
# Each file is an invented nitrogen trial on one corn field: columns plot,
# n_rate (lb/acre) and yield (bu/acre). Six nitrogen rates (0 to 250 lb/acre),
# each repeated 4, 5 or 6 times depending on the field, so files differ in
# length. Yield follows a field-specific quadratic response plus noise.
#
# Two features are deliberate, for the exercise:
#   - No column says which field a file is; the field is only in the file name.
#   - field_07.csv has yield in kg/ha (bu/acre x 62.77) instead of bu/acre,
#     with the same column name. Nothing errors; only a range check finds it.
#
# Run from the repo root: Rscript exercises/data-prep/make-5-1-nitrogen-trials.R

set.seed(5101)

n_fields <- 12
rates <- seq(0, 250, by = 50)
reps <- sample(4:6, n_fields, replace = TRUE)

out_dir <- file.path(tempdir(), "nitrogen-trials")
unlink(out_dir, recursive = TRUE)
dir.create(out_dir)

for (f in seq_len(n_fields)) {
  base <- runif(1, 110, 150)
  slope <- runif(1, 0.9, 1.4)
  peak <- runif(1, 190, 240)
  curve <- -slope / (2 * peak)
  n_rate <- sample(rep(rates, each = reps[f]))
  yield <- base + slope * n_rate + curve * n_rate^2 + rnorm(length(n_rate), 0, 8)
  if (f == 7) yield <- yield * 62.77
  d <- data.frame(plot = seq_along(n_rate), n_rate = n_rate, yield = round(yield, 1))
  write.csv(d, file.path(out_dir, sprintf("field_%02d.csv", f)), row.names = FALSE)
}

zip_path <- normalizePath(file.path("exercises", "data"), mustWork = TRUE)
zip_path <- file.path(zip_path, "5-1-nitrogen-trials.zip")
unlink(zip_path)
old <- setwd(tempdir())
utils::zip(zip_path, "nitrogen-trials", flags = "-r9Xq")
setwd(old)
