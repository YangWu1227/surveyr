#' Combine the results of `apply_topline_multiselect()`
#'
#' @description
#' This function completes the \strong{split-apply-combine} workflow in handling multiple selection questions
#' in the survey. This is a helper function that accepts the output of `apply_topline_multiselect()` containing two
#' lists--- `return` and `error`. It will either \strong{1)} throw an error indicating that attention must be paid to
#' the `error` list, or \strong{2)} return a single list of toplines, which can then be passed to `print_tbls()`.
#'
#' @param l A list of lists as returned by `apply_topline_multiselect()`.
#'
#' @return A list of `flextable` objects.
#'
#' @importFrom purrr flatten
#' @export
#'
#' @examples
#' \donttest{
#' # Vector of patterns
#' patterns <- c("prefix_1", "predix_2", ...)
#'
#' # List of data.tables
#' list_df <- split_df(df, patterns, "weight_var")
#'
#' # Apply topline generation to each element of 'list_df'
#' captions <- c("caption_1", "caption_2", ...)
#' parents <- c(TRUE, FALSE, ...)
#' results <- apply_topline_multiselect(list_df, "weight_var", captions, parents)
#'
#' # Combine the results
#' list_of_toplines <- combine_topline_multiselect(l = results)
#' }
combine_topline_multiselect <- function(l) {
  if (!is.list(l) | !length(l) == 2 | !all(c("error", "result") %in% names(l))) {
    stop("'l' must be the output of `apply_topline_multiselect()`", call. = FALSE)
  }
  if (!all(map_lgl(l[["error"]], is.null))) {
    stop("The `error` list contains failures, please examine", call. = FALSE)
  }

  list_of_toplines <- flatten(l[["result"]])
  list_of_toplines
}
