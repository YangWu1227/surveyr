#' Generate multiple lists of crosstab arguments
#'
#' @description
#' Simply put, `list_xtab_args()` is a vectorized version of `generate_xtab_args()`. The function
#' `generate_xtab_args()` allows for one `var_of_interest` at a time. There may be use cases where
#' multiple `var_of_interest` must be considered. In those cases, this function may be useful as it
#' allows users to pass a vector of `var_of_interest` and a corresponding list of `dependent_vars`.
#' These two vectors must be of the same length in terms of `vec_size()`. One may think of these two
#' vectors as pairs in the sence that--- each ith element in `var_of_interest` is crossed with each
#' element of `dependent_vars`, which is a vector in and of itself. If no `dependent_vars` list is
#' specified, the function defaults to crossing each variable in `var_of_interest` with all other
#' columns in `df` unless `rm` is specified.
#'
#'
#'
#' @param df A data frame or tibble.
#' @param var_of_interest A character vector of variables of interest.
#' @param dependent_vars A list of character vectors, each of which contains dependent variables. Defaults
#'   to crossing each element of `var_of_interest` with all other variables in `df` if `rm` is `NULL`.
#' @param rm A character vector of variables to be removed from consideration. Defaults to `NULL`.
#'
#' @return A list containing two elements--- `result` and `error`, which are lists in and of themselves.
#'   These two lists have the same structure and number of elements. The `result` is a \strong{named} list
#'   of `tibble` objects. One can think of each `tibble` as the output of a single run of `generate_xtab_args()`,
#'   \emph{if it suceeds.} The `error` list captures all runs of `generate_xtab_args()` that have failed,
#'   returning the error messages. If all run fails, `result` will be a `NULL` list; on the other end, if no run
#'   fails, `error` will be a `NULL` list. Users can easily find out which `var_of_interest` failed by examining
#'   the `error` list and running the following code (assuming that the list is called `list_of_args` and the
#'   vector of variables of interest is called `var_of_interest`):
#'   \preformatted{
#'         lgl_index <- purrr::map_lgl(list_of_args[["error"]], is.null)
#'         var_of_interest[!lgl_index]
#'   }
#'   To examine the results of the successful runs, use:
#'   \preformatted{
#'         list_of_args[["result"]][lgl_index]
#'   }
#'   Or, if all runs are successful, simply return the `result` list:
#'   \preformatted{
#'         list_of_xtab_args <- list_of_args[["result"]]
#'   }
#'
#' @importFrom purrr safely
#' @importFrom purrr transpose
#' @importFrom purrr map
#' @export
#'
#' @examples
#' # Create var_of_interest vector
#' var_of_interest <- c("col1", "col3", "col20", "col23", "col32")
#'
#' # List of dependent variable vectors
#' dependent_vars <- list(
#'   c("col2", "col4", "col5", "col100"),
#'   c("col2", "col4"),
#'   c("col2", "col4", "col5", "col86"),
#'   NULL,
#'   c("col2", "col4"),
#' )
#'
#' # Create list_of_args
#' list_of_args <- list_xtabs_args(df_, var_of_interest, dependent_vars)
list_xtab_args <- function(df, var_of_interest, dependent_vars = NULL, rm = NULL) {
  if (!is_character(var_of_interest)) {
    stop("'var_of_intereset' must be a character vector", call. = FALSE)
  }

  safe_generate_xtab_args <- safely(.f = generate_xtab_args)

  # First case
  if (rlang::is_null(dependent_vars)) {
    list_args <- map(
      .x = var_of_interest,
      .f = safe_generate_xtab_args,
      # Constant args
      df = df,
      dependent_vars = dependent_vars,
      rm = rm
    ) %>%
      purrr::transpose()

    names(list_args[["result"]]) <- var_of_interest
    names(list_args[["error"]]) <- var_of_interest
    list_args
    # Second case
  } else if (!rlang::is_null(dependent_vars)) {
    if (!is_list(dependent_vars)) {
      stop("'dependent_vars' must be a list object", call. = FALSE)
    }
    if (vec_size(dependent_vars) != vec_size(var_of_interest)) {
      stop("'dependent_vars' and 'var_of_interest' must have the same length", call. = FALSE)
    }

    list_args <- pmap(
      .l = list(
        var_of_interest = var_of_interest,
        dependent_vars = dependent_vars
      ),
      .f = safe_generate_xtab_args,
      # Constant args
      df = df,
      rm = rm
    ) %>%
      purrr::transpose()

    names(list_args[["result"]]) <- var_of_interest
    names(list_args[["error"]]) <- var_of_interest
    list_args
  }
}

#' Flatten list of tibble objects into a single tibble
#'
#' @description
#' This is a helper function that accepts the output of `list_xtab_args()` containing two lists--- `return`
#' and `error`. It will either \strong{1)} throw an error indicating that attention must be paid to the `error`
#' list, or \strong{2)} return a single list of arguments, which can then be passed to `generate_tbls()`.
#'
#' @param l A list of list as returned by `list_xtab_args()`.
#'
#' @return A single tibble of crosstab arguments to be passed to `generate_tbls(type = "crosstab")`.
#'
#' @seealso [list_xtab_args()] for vectorized crosstab arguments generation and [generate_tbls()] for
#'   multiple tables generation.
#'
#' @importFrom data.table rbindlist
#' @importFrom tibble as_tibble
#' @importFrom rlang is_list
#' @importFrom purrr map_lgl
#' @export
#'
#' @examples
#' # Generate arguments list for crosstabs
#' list_xtabs_args(df, var_of_interest, dependent_vars, rm) %>%
#'   flatten_args(l = .)
flatten_args <- function(l) {
  if (!is_list(l, n = 2) | !all(c("error", "result") %in% names(l))) {
    stop("'l' must be the output of `list-xtab_args()`", call. = FALSE)
  }

  # If the error list is not a NULL list, throw an error
  if (!all(map_lgl(l[["error"]], rlang::is_null))) {
    stop("The `error` list contains failures, please examine", call. = FALSE)
  }
  list_of_args <- as_tibble(rbindlist(l[["result"]]))
  list_of_args
}
