#' Iteratively generate multiple tables
#'
#' @description
#' This function provides a wrapper around `generate_xtab()`, `generate_xtab_3way()`, and `generate_topline()`,
#' allowing users to efficiently generate many tables by passing a list of arguments. The shapes of the argument
#' lists may vary depending on the table `type`.
#'
#' @param l A list of arguments to be passed on to either `generate_xtab()`, `generate_xtab_3way()`, or `generate_topline()`:
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
#'      "var_1", "var_2", "caption1",
#'      "var_2", "var_9", "caption2",
#'      "var_3", "var_23", "caption3",
#'      .
#'      .
#'      .
#'   )}}
#'   \item{For three-way crosstabs}{
#'   \preformatted{list_xtab <- tibble::tribble(
#'      ~x, ~y, ~z, ~caption,
#'      "var_1", "var_2", "var_3", "caption1",
#'      "var_2", "var_9", "var_1", "caption2",
#'      "var_3", "var_23", "var_17", "caption3",
#'      .
#'      .
#'      .
#'   )}}
#' }
#' @param df A data frame or tibble.
#' @param weight A length one character vector used as the caption for the topline.
#' @param type Must either be 'topline', 'crosstab_2way', or 'crosstab_3way'. Defaults to 'topline'.
#'
#' @return A list containing elements that are list objects, each of which is the source code for a single
#' `s3` list object of class `flextable`.
#'
#' @seealso [generate_xtab()], [generate_xtab_3way()], and [generate_topline()] for single crosstab or topline generations.
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
#'   "crosstab_2way"
#' )
#'
#' #' list_of_xtabs <- generate_tbls(
#'   l = list_xtab,
#'   df,
#'   "weight",
#'   "crosstab_3way"
#' )
#'
#' # Generate toplines
#' list_of_topline <- generate_tbls(
#'   l = list_topline,
#'   df,
#'   "weight",
#'   "topline"
#' )
#' }
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
  if (!is.data.frame(l) | !is.data.frame(df)) {
    stop("The argument 'l' and 'df' must be objects inheriting from data frame", call. = FALSE)
  }
  if (!is.character(weight) | !length(weight) == 1 | !weight %in% names(df)) {
    stop("The argument 'weight' must be a single column name found in 'df'", call. = FALSE)
  }
  if (!is.character(type) | !length(type) == 1) {
    stop("The argument 'type' must be a length-one character vector", call. = FALSE)
  }

  switch(type,
    topline = {
      list_of_tables <- pmap(
        .l = l,
        .f = generate_topline,
        # Constant arguments
        df = df,
        weight = {{ weight }}
      )
    },
    crosstab_2way = {
      list_of_tables <- pmap(
        .l = l,
        .f = generate_xtab,
        # Constant arguments
        df = df,
        weight = {{ weight }}
      )
    },
    crosstab_3way = {
      list_of_tables <- pmap(
        .l = l,
        .f = generate_xtab_3way,
        # Constant arguments
        df = df,
        weight = {{ weight }}
      )
    },
    stop("The argument 'type' must either be 'crosstab', 'crosstab_3way', 'topline'", call. = FALSE)
  )

  list_of_tables
}
