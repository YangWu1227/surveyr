#' Iteratively generate multiple tables
#'
#' This function provides a wrapper around `generate_xtab_*()` and `generate_topline_*()`, allowing users
#' to efficiently generate many tables by passing a list of arguments. The shapes of the argument lists
#' may vary depending on the table `type`.
#'
#' @param l A list of arguments to be passed on to either `generate_xtab_*()` or `generate_topline_*()`:
#' \describe{
#'   \item{For toplines}{
#'   \preformatted{list_topline <- tibble::tribble(
#'      ~x, ~caption,
#'      "var_1", "caption1",
#'      "var_2", "caption2",
#'      "var_3", "caption3",
#'      .
#'      .
#'      .
#'   )}}
#'   \item{For crosstabs}{
#'   \preformatted{list_xtab <- tibble::tribble(
#'      ~x, ~y, ~caption,
#'      "var_1", "var_2" "caption1",
#'      "var_2", "var_9", caption2",
#'      "var_3", "var_23", "caption3",
#'      .
#'      .
#'      .
#'   )}}
#' }
#' @param df A data frame or tibble.
#' @param weight A length one character vector used as the caption for the topline.
#' @param type Must either be 'topline' or 'crosstab'. Defaults to 'topline'.
#' @param output Must either be 'latex' or 'word'. Defaults to 'word'.
#'
#' @return A list containing elements that are length one character vectors (latex) or lists objects (word), each of which is the source code for a single
#' table (latex) or a `s3` list object (word).
#'
#' @seealso [generate_xtab_docx()], [generate_xtab_latex()], [generate_topline_docx()], and [generate_topline_latex()] for single crosstab or topline generation.
#'
#' @importFrom purrr pmap
#' @export
#'
#' @examples
#' \donttest{
#' # Generate crosstabs
#' list_of_xtabs <- generate_tbls(
#'   l = list_xtab,
#'   df,
#'   "weight",
#'   "crosstab",
#'   "word"
#' )
#'
#' # Generate toplines
#' list_of_topline <- generate_tbls(
#'   l = list_topline,
#'   df,
#'   "weight",
#'   "topline",
#'   "latex"
#' )
#' }
generate_tbls <- function(l, df, weight, type = "topline", output = "word") {
  tryCatch(
    error = function(cnd) stop("Please place quotes around the argument 'weight'", call. = FALSE),
    {
      weight
    }
  )
  tryCatch(
    error = function(cnd) stop("Please place quotes around the argument 'type'", call. = FALSE),
    {
      type
    }
  )
  tryCatch(
    error = function(cnd) stop("Please place quotes around the argument 'output'", call. = FALSE),
    {
      output
    }
  )
  if (!"data.frame" %in% class(l) | !"data.frame" %in% class(df)) {
    stop("The argument 'l' and 'df' must be objects inheriting from data frame", call. = FALSE)
  }
  if (!is_character(weight, n = 1) | !weight %in% names(df)) {
    stop("The argument 'weight' must be a single column name found in 'df'", call. = FALSE)
  }
  if (!is_character(type, n = 1)) {
    stop("The argument 'type' must be a length-one character vector", call. = FALSE)
  }
  if (!is_character(output, n = 1)) {
    stop("The argument 'output' must be a length-one character vector", call. = FALSE)
  }

  if (output == "word") {
    switch(type,
      topline = {
        list_of_tables <- pmap(
          .l = l,
          .f = generate_topline_docx,
          # Constant arguments
          df = df,
          weight = {{ weight }}
        )
      },
      crosstab = {
        list_of_tables <- pmap(
          .l = l,
          .f = generate_xtab_docx,
          # Constant arguments
          df = df,
          weight = {{ weight }}
        )
      },
      stop("The argument 'type' must either be 'crosstab' or 'topline'", call. = FALSE)
    )
  } else if (output == "latex") {
    switch(type,
      topline = {
        list_of_tables <- pmap(
          .l = l,
          .f = generate_topline_latex,
          # Constant arguments
          df = df,
          weight = {{ weight }}
        )
      },
      crosstab = {
        list_of_tables <- pmap(
          .l = l,
          .f = generate_xtab_latex,
          # Constant arguments
          df = df,
          weight = {{ weight }}
        )
      },
      stop("The argument 'type' must either be 'crosstab' or 'topline'", call. = FALSE)
    )
  } else {
    stop("The argument 'output' must either be 'word' or 'latex'", call. = FALSE)
  }

  list_of_tables
}
