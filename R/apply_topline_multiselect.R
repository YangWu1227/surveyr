#' Apply topline generation to a list of data frames
#'
#' @description
#' This function is the second part of the \strong{split-apply-combine} workflow in handling multiple selection questions
#' in the survey. It takes the result of `split_df()`,
#'
#' @param list_df A list of data frame objects.
#' @param weight A single string of the weighting variable.
#' @param caption A list of character vectors of captions for the toplines.
#' @param parent A logical vector of booleans indicating whether `df` has a parent response column.
#'
#' @return A list containing two elements--- `result` and `error`, which are lists in and of themselves.
#'   These two lists have the same structure and number of elements. The `result` is a list
#'   of list objects. One can think of each element in `result` as the output of a single run of
#'   `generate_topline_multiselect()`, \emph{if it suceeds.} The `error` list captures all runs of
#'   `generate_topline_multiselect()` that have failed, returning the error messages. If all run fails,
#'   `result` will be a `NULL` list; on the other end, if no run fails, `error` will be a `NULL` list.
#'
#' @seealso [generate_topline_multiselect()] for single topline generation for multiple selection questions,
##'   [split_df()] for splitting a single data frame into smaller subsets, and [combine_topline_multiselect()]
##'   for combining the multiselect toplines.
#'
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
#' }
apply_topline_multiselect <- function(list_df, weight, caption, parent) {
  if (!all(vapply(X = list_df, FUN = is.data.frame, FUN.VALUE = logical(length = 1)))) {
    stop("The argument 'list_df' must be a list of data frames", call. = FALSE)
  }
  if (!is.character(weight) | !is.list(caption) | !is.logical(parent)) {
    stop(
      "The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively",
      call. = FALSE
    )
  }

  # Safe function
  safe_generate_topline_multiselect <- safely(.f = generate_topline_multiselect)

  list_multiselect <- pmap(
    .l = list(df = list_df, caption = caption, parent = parent),
    .f = safe_generate_topline_multiselect,
    weight = weight
  ) %>%
    purrr::transpose()

  list_multiselect
}
