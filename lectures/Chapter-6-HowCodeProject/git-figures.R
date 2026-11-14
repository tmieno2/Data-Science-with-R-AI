# Figures for 06-2-version-control.qmd: the git diagrams, drawn with ggplot2.
#
#   Rscript lectures/Chapter-6-HowCodeProject/git-figures.R
#
# Copied from the old course (Data-Science-with-R-Quarto) and trimmed to the
# diagrams 06-2 uses. rstudio-git-pane.png is a screenshot crop made by the old
# script from that course's Chapter 2 pictures; it is kept as a plain image.
# Backgrounds are transparent so each figure sits on the slide's paper colour.

library(ggplot2)

here_dir <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd()
}
dir <- here_dir()
out <- file.path(dir, "git-figures")
dir.create(out, showWarnings = FALSE)

pal <- c(
  ink = "#22201b", muted = "#5d574a", accent = "#1d4e89", sienna = "#a8552b",
  tint = "#eef2f8", warm = "#f6efe6", faded = "#b9b2a5"
)

r <- 0.38 # commit circle radius, in data units

circle <- function(x, y, id, r = 0.38, n = 80) {
  t <- seq(0, 2 * pi, length.out = n)
  data.frame(x = x + r * cos(t), y = y + r * sin(t), id = id)
}

# A segment from one point to another, pulled back by r1 at the start and r2 at
# the end so arrows meet circle edges instead of centres.
seg <- function(x1, y1, x2, y2, r1 = r, r2 = r) {
  dx <- x2 - x1
  dy <- y2 - y1
  l <- sqrt(dx^2 + dy^2)
  data.frame(
    x = x1 + dx / l * r1, y = y1 + dy / l * r1,
    xend = x2 - dx / l * r2, yend = y2 - dy / l * r2
  )
}

arw <- arrow(type = "closed", length = unit(0.13, "inches"), angle = 22)

# commits: data frame with id, x, y, and optionally fill / line colour / linetype
draw_commits <- function(commits) {
  if (is.null(commits$fill)) commits$fill <- pal[["tint"]]
  if (is.null(commits$line)) commits$line <- pal[["accent"]]
  if (is.null(commits$lty)) commits$lty <- "solid"
  if (is.null(commits$text)) commits$text <- pal[["ink"]]
  polys <- do.call(rbind, lapply(seq_len(nrow(commits)), function(i) {
    p <- circle(commits$x[i], commits$y[i], commits$id[i])
    p$fill <- commits$fill[i]
    p$line <- commits$line[i]
    p$lty <- commits$lty[i]
    p
  }))
  list(
    geom_polygon(
      data = polys,
      aes(x, y, group = id, fill = I(fill), colour = I(line), linetype = I(lty)),
      linewidth = 0.9
    ),
    geom_text(
      data = commits, aes(x, y, label = id, colour = I(text)),
      size = 5.2, fontface = "bold"
    )
  )
}

# links: data frame of from / to commit ids (child -> parent)
draw_links <- function(links, commits, colour = pal[["muted"]], lty = "solid") {
  s <- do.call(rbind, lapply(seq_len(nrow(links)), function(i) {
    a <- commits[commits$id == links$from[i], ]
    b <- commits[commits$id == links$to[i], ]
    seg(a$x, a$y, b$x, b$y, r + 0.03, r + 0.06)
  }))
  geom_segment(
    data = s, aes(x, y, xend = xend, yend = yend),
    colour = colour, linewidth = 0.8, arrow = arw, linetype = lty
  )
}

# A branch name or HEAD, drawn as a label
name_label <- function(x, y, label, head = FALSE) {
  geom_label(
    data = data.frame(x = x, y = y, label = label),
    aes(x, y, label = label),
    fill = if (head) "#e2dcd0" else pal[["warm"]],
    colour = if (head) pal[["ink"]] else pal[["sienna"]],
    fontface = "bold", size = 4.8, linewidth = 0.6,
    label.r = unit(0.2, "lines"), label.padding = unit(0.3, "lines")
  )
}

pointer <- function(x1, y1, x2, y2) {
  geom_segment(
    data = data.frame(x = x1, y = y1, xend = x2, yend = y2),
    aes(x, y, xend = xend, yend = yend),
    colour = pal[["sienna"]], linewidth = 0.8, arrow = arw
  )
}

save_fig <- function(p, name, xlim, ylim, width) {
  height <- width * diff(ylim) / diff(xlim)
  p <- p +
    coord_fixed(xlim = xlim, ylim = ylim, expand = FALSE, clip = "off") +
    theme_void() +
    theme(plot.background = element_rect(fill = "transparent", colour = NA))
  ggsave(
    file.path(out, name), p,
    width = width, height = height, dpi = 200,
    device = ragg::agg_png, bg = "transparent"
  )
  message(sprintf("%-22s %.1f x %.1f in", name, width, height))
}

# ── 1. The three places a file can be ─────────────────────────────────────────

boxes <- data.frame(
  x = c(0, 5, 10),
  title = c("Your project folder", "Staging area", "Repository"),
  sub = c(
    "the files as you\nsee and edit them",
    "the changes selected\nfor the next commit",
    "the commits, kept in\nthe hidden .git folder"
  ),
  fill = c(pal[["warm"]], pal[["tint"]], pal[["tint"]])
)
moves <- data.frame(
  x = c(1.7, 6.7), xend = c(3.3, 8.3), y = 0,
  cmd = c("git add", "git commit"),
  rstudio = c("tick Staged", "click Commit")
)

p <- ggplot() +
  geom_rect(
    data = boxes,
    aes(xmin = x - 1.6, xmax = x + 1.6, ymin = -1, ymax = 1, fill = I(fill)),
    colour = pal[["accent"]], linewidth = 0.9
  ) +
  geom_text(
    data = boxes, aes(x, 0.5, label = title),
    size = 5.4, fontface = "bold", colour = pal[["ink"]]
  ) +
  geom_text(
    data = boxes, aes(x, -0.3, label = sub),
    size = 4.4, colour = pal[["muted"]], lineheight = 0.95
  ) +
  geom_segment(
    data = moves, aes(x, y, xend = xend, yend = y),
    colour = pal[["accent"]], linewidth = 1.1, arrow = arw
  ) +
  geom_text(
    data = moves, aes((x + xend) / 2, 0.38, label = cmd),
    size = 4.6, family = "mono", fontface = "bold", colour = pal[["accent"]]
  ) +
  geom_text(
    data = moves, aes((x + xend) / 2, -0.38, label = rstudio),
    size = 4.2, colour = pal[["muted"]]
  )
save_fig(p, "three-places.png", c(-1.75, 11.75), c(-1.15, 1.15), 10)

# ── 2. History: commits, main, HEAD ──────────────────────────────────────────

h <- data.frame(id = c("A", "B", "C", "D"), x = c(0, 1.6, 3.2, 4.8), y = 0)
p <- ggplot() +
  draw_links(data.frame(from = c("B", "C", "D"), to = c("A", "B", "C")), h) +
  draw_commits(h) +
  pointer(4.8, 0.95, 4.8, r + 0.08) +
  name_label(4.8, 1.25, "main") +
  pointer(6.05, 1.25, 5.42, 1.25) +
  name_label(6.6, 1.25, "HEAD", head = TRUE)
save_fig(p, "history.png", c(-0.55, 7.3), c(-0.55, 1.65), 8)

# ── 3. A branch ──────────────────────────────────────────────────────────────

b <- data.frame(
  id = c("A", "B", "C", "E", "F"),
  x = c(0, 1.6, 3.2, 4.8, 6.4), y = c(0, 0, 0, -1.3, -1.3)
)
p <- ggplot() +
  draw_links(data.frame(from = c("B", "C", "E", "F"), to = c("A", "B", "C", "E")), b) +
  draw_commits(b) +
  pointer(3.2, 0.95, 3.2, r + 0.08) +
  name_label(3.2, 1.25, "main") +
  pointer(7.45, -1.3, 6.4 + r + 0.08, -1.3) +
  name_label(8.25, -1.3, "revision") +
  pointer(9.8, -1.3, 9.15, -1.3) +
  name_label(10.35, -1.3, "HEAD", head = TRUE)
save_fig(p, "branch.png", c(-0.55, 11.05), c(-1.85, 1.65), 9)

# ── 4. A merge ───────────────────────────────────────────────────────────────

m <- data.frame(
  id = c("A", "B", "C", "D", "E", "F", "M"),
  x = c(0, 1.6, 3.2, 4.8, 4.8, 6.4, 8.0),
  y = c(0, 0, 0, 0, -1.3, -1.3, 0),
  fill = c(rep(pal[["tint"]], 6), pal[["warm"]])
)
p <- ggplot() +
  draw_links(
    data.frame(
      from = c("B", "C", "D", "E", "F", "M", "M"),
      to = c("A", "B", "C", "C", "E", "D", "F")
    ), m
  ) +
  draw_commits(m) +
  pointer(8.0, 0.95, 8.0, r + 0.08) +
  name_label(8.0, 1.25, "main") +
  pointer(9.25, 1.25, 8.62, 1.25) +
  name_label(9.8, 1.25, "HEAD", head = TRUE) +
  pointer(7.45, -1.3, 6.4 + r + 0.08, -1.3) +
  name_label(8.25, -1.3, "revision")
save_fig(p, "merge.png", c(-0.55, 10.5), c(-1.85, 1.65), 9)

# ── 5. Your computer and GitHub ──────────────────────────────────────────────

ops <- data.frame(
  y = c(3.0, 2.0, 1.0, 0.0),
  dir = c("left", "right", "left", "left"),
  cmd = c("git clone", "git push", "git fetch", "git pull"),
  what = c(
    "first time only", "send your new commits",
    "download only", "download and merge"
  ),
  lty = c("dashed", "solid", "solid", "solid")
)
ops$x <- ifelse(ops$dir == "right", 1.05, 4.95)
ops$xend <- ifelse(ops$dir == "right", 4.95, 1.05)

p <- ggplot() +
  geom_rect(
    data = data.frame(
      xmin = c(-1.0, 5.1), xmax = c(0.9, 7.0),
      fill = c(pal[["warm"]], pal[["tint"]])
    ),
    aes(xmin = xmin, xmax = xmax, ymin = -0.6, ymax = 3.6, fill = I(fill)),
    colour = pal[["accent"]], linewidth = 0.9
  ) +
  geom_text(
    data = data.frame(
      x = c(-0.05, 6.05), y = 1.6,
      label = c("Your\ncomputer", "GitHub")
    ),
    aes(x, y, label = label),
    size = 5.4, fontface = "bold", colour = pal[["ink"]], lineheight = 0.95
  ) +
  geom_text(
    data = data.frame(
      x = c(-0.05, 6.05), y = 0.55,
      label = c("your\nrepository", "the remote,\ncalled\norigin")
    ),
    aes(x, y, label = label),
    size = 4.3, colour = pal[["muted"]], lineheight = 0.95
  ) +
  geom_segment(
    data = ops, aes(x, y, xend = xend, yend = y, linetype = I(lty)),
    colour = pal[["accent"]], linewidth = 1, arrow = arw
  ) +
  geom_text(
    data = ops, aes(3, y + 0.3, label = cmd),
    size = 4.9, family = "mono", fontface = "bold", colour = pal[["accent"]]
  ) +
  geom_text(
    data = ops, aes(3, y - 0.3, label = what),
    size = 4.3, colour = pal[["muted"]]
  )
save_fig(p, "remote.png", c(-1.15, 7.15), c(-0.75, 3.75), 5)
