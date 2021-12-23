# Custom linebreak functions ----------------------------------------------

#' @importFrom stringr str_detect
#' @importFrom stringr str_replace_all
linebreak_grey <- function(x, align = "l", linebreaker = "\n") {
  ifelse(str_detect(x, linebreaker),
    paste0(
      "\\cellcolor[HTML]{e5e5e5}{\\colorbox[HTML]{e5e5e5}{\\makecell[", align, "]{",
      str_replace_all(x, linebreaker, "\\\\\\\\"), "}}}"
    ),
    x
  )
}

linebreak_white <- function(x, align = "l", linebreaker = "\n") {
  ifelse(str_detect(x, linebreaker),
    paste0(
      "\\cellcolor[HTML]{ffffff}{\\colorbox[HTML]{ffffff}{\\makecell[", align, "]{",
      str_replace_all(x, linebreaker, "\\\\\\\\"), "}}}"
    ),
    x
  )
}
