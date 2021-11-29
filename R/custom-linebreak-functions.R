# Custom linebreak functions ----------------------------------------------

linebreak_grey <- function(x, align = "l", linebreaker = "\n") {
  ifelse(stringr::str_detect(x, linebreaker),
    paste0(
      "\\cellcolor[HTML]{e5e5e5}{\\colorbox[HTML]{e5e5e5}{\\makecell[", align, "]{",
      stringr::str_replace_all(x, linebreaker, "\\\\\\\\"), "}}}"
    ),
    x
  )
}
linebreak_white <- function(x, align = "l", linebreaker = "\n") {
  ifelse(stringr::str_detect(x, linebreaker),
    paste0(
      "\\cellcolor[HTML]{ffffff}{\\colorbox[HTML]{ffffff}{\\makecell[", align, "]{",
      stringr::str_replace_all(x, linebreaker, "\\\\\\\\"), "}}}"
    ),
    x
  )
}
