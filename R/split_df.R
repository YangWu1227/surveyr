#' Split a single data frame into a list of data frames
#'
#' @description
#' This function is the first part of the \strong{split-apply-combine} workflow in handling multiple selection questions in the
#' survey. In multi-select, participants are able to choose from a menu of choices provided. From a data perspective,
#' multi-select responses are recorded in wide format where each column represents a single choice in a multi-select
#' question. Related columns, i.e., those belonging to the same multi-select question, are grouped together using homogeneous
#' "prefixes." This function takes a single data frame, divides it into subsets based on patterns in the column names (the
#' "prefixes"), and returns a list containing the subsets.
#'
#'
#' @param df A data frame or data.table or tibble.
#' @param patterns A character vector of "prefixes" for selecting columns in `df`.
#' @param weight A single string of the weighting variable.
#'
#' @return A list of data frames, each of which is a `data.table` object.
#'
#' @seealso [apply_topline_multiselect()] for vectorized topline generation for multiple selection questions and
#'   [combine_topline_multiselect()] for combining the multiselect toplines.
#'
#' @importFrom glue glue
#' @export
#'
#' @examples
#' \donttest{
#' # Vector of patterns
#' patterns <- c("prefix_1", "predix_2", ...)
#'
#' # List of data.tables
#' list_df <- split_df(df, patterns, "weight_var")
#' }
split_df <- function(df, patterns, weight) {
  if (!is.data.frame(df) | !is.character(patterns) | !is.character(weight)) {
    stop("The arguments 'df', 'patterns', and 'weight' must be data frame object and character vectors, respectively",
      call. = FALSE
    )
  }
  if (!weight %in% names(df)) {
    stop("The argument 'weight' must exist in 'df'", call. = FALSE)
  }

  # Coerce to data.table
  class(df) <- c("data.table", "data.frame")

  df_list <- lapply(
    X = patterns,
    FUN = function(pattern) {
      df[, .SD, .SDcols = patterns(glue("^({pattern}|{weight})"))]
    }
  )

  # Set list names to 'patterns' for easier access to elements via name attributes
  names(df_list) <- patterns

  df_list
}
