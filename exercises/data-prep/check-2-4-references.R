# exercises/data/2-4-references.bib was written by hand for exercise 2-4.
#
# schlenker2009 and lobell2014 are real; their fields were copied from the
# publishers' records (https://doi.org/<DOI> with Accept: application/x-bibtex).
#
# hansen2017 is PLANTED: the article does not exist. Its DOI is real but
# belongs to a different article (Horan and Shortle 2017, "Endogenous Risk and
# Point-Nonpoint Uncertainty Trading Ratios", AJAE 99(2): 427-446); its
# volume, issue and pages were copied from that article so that only the
# title and authors give it away. Finding this is the point of Task 5.
#
# This script looks every DOI up at Crossref and prints the title and first
# author Crossref has, next to the .bib entry's. Needs internet.
# Run from the repo root: Rscript exercises/data-prep/check-2-4-references.R

bib <- readLines(here::here("exercises", "data", "2-4-references.bib"))
keys <- sub("^@article\\{(.*),$", "\\1", grep("^@article", bib, value = TRUE))
dois <- sub(".*\\{(.*)\\}.*", "\\1", grep("^\\s*doi", bib, value = TRUE))
titles <- sub(".*\\{(.*)\\},?$", "\\1", grep("^\\s*title", bib, value = TRUE))

for (i in seq_along(keys)) {
  m <- jsonlite::fromJSON(paste0("https://api.crossref.org/works/", dois[i]))$message
  cat(
    keys[i], "\n",
    "  .bib title:     ", titles[i], "\n",
    "  Crossref title: ", m$title, "\n",
    "  Crossref author:", m$author$family[1], "\n"
  )
}
