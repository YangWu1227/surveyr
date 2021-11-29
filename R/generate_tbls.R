#' Iteratively generate multiple tables
#'
#' This function provides a wrapper around `generate_xtab()` and `generate_topline()`, allowing users
#' to efficiently generate many tables by passing a list of arguments. The shapes of the argument lists
#' may vary depending on the table `type`.
#'
#' @param l A list of arguments to be passed on to either `generate_xtab()` or `generate_topline()`:
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
#'
#' @return A list containing elements that are length one character vectors, each of which is the source code for a single
#' table.
#'
#' @seealso [generate_xtab()] and [generate_topline()] for single crosstab or topline generation.
#'
#' @importFrom purrr pmap
#' @export
#'
#' @examples
#' # Generate crosstabs
#' list_of_xtabs <- generate_tbls(
#'   l = list_xtab,
#'   df,
#'   "weight",
#'   "crosstab"
#' )
#'
#' # Generate toplines
#' list_of_topline <- generate_tbls(
#'   l = list_topline,
#'   df,
#'   "weight",
#'   "topline"
#' )
generate_tbls <- function(l, df, weight, type = "topline") {
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
  if (!"data.frame" %in% class(l) | !"data.frame" %in% class(df)) {
    stop("The argument 'l' and 'df' must be objects inheriting from data frame", call. = FALSE)
  }
  if (!is_character(weight, n = 1) | !weight %in% names(df)) {
    stop("The argument 'weight' must be a single column name found in 'df'", call. = FALSE)
  }

  if (type == "topline") {
    list_of_tables <- pmap(
      .l = l,
      .f = generate_topline,
      # Constant arguments
      df = df,
      weight = {{ weight }}
    )
  } else if (type == "crosstab") {
    list_of_tables <- pmap(
      .l = l,
      .f = generate_xtab,
      # Constant arguments
      df = df,
      weight = {{ weight }}
    )
  } else {
    stop("The argument 'type' must either be 'topline' or 'crosstab'", call. = FALSE)
  }

  list_of_tables
}
