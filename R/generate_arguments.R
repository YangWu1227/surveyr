# Crosstab ----------------------------------------------------------------

#' Generate a list of crosstab arguments
#'
#' @description
#' This function is helper for `generate_tbls()`. It automatically generates a list of arguments to be
#' passed on to `generate_tbls()` for a given set of arguments. This may be useful when the number of
#' variables in a data frame is large, and there is a need to generate varying arguments efficiently.
#'
#' @param df A data frame or tibble.
#' @param var_of_interest A single string of the variable of interest.
#' @param dependent_vars A character vector of dependent variables. Defaults to crossing `var_of_interest`
#'   with all other variables in `df` unless `rm` is `NULL`.
#' @param rm A character vector of variables to be removed from consideration. Defaults to `NULL`.
#'
#' @return A list of arguments. If n tables were to be generated, this is a `tibble` with dimensions (n, 3).
#'
#' @seealso [generate_tbls()] for an example of a list of arguments.
#'
#' @importFrom tibble tibble
#' @importFrom stringr str_to_title
#' @export
#'
#' @examples
#' \donttest{
#' # Generate list of arguments
#' generate_xtab_args(df, "var_of_interest")
#'
#' # Specified dependent variables and removal variables
#' dependent_vars <- c("col1", "col2")
#' rm <- c("col19", "col20")
#' generate_xtab_args(df, "var_of_interest", dependent_vars, rm)
#' }
generate_xtab_args <- function(df, var_of_interest, dependent_vars = NULL, rm = NULL) {
  if (!is.data.frame(df)) stop("'df' must be a data frame", call. = FALSE)
  if (!is_character(var_of_interest, n = 1) | !all(var_of_interest %in% names(df))) {
    stop("The argument 'var_of_interest' must be a single column name found in 'df'", call. = FALSE)
  }

  #############################################################################################
  # If no user-supplied dependent variable vector, default to crossing with all other columns #
  #############################################################################################

  if (rlang::is_null(dependent_vars)) {

    ########################################################################
    # First case: if "dependent_vars" is NULL, remove columns if specified #
    ########################################################################

    if (!rlang::is_null(rm)) {
      # If 'rm' is not NULL, "rm" must be a character vector
      if (!is.character(rm)) {
        stop("The argument 'rm' must be a character vector", call. = FALSE)
      }
      # If 'rm' is not NULL, check if "rm" is in "df"
      if (!all(rm %in% names(df))) {
        stop("The argument 'rm' must contain columns in 'df'", call. = FALSE)
      }
      # Set "dependent_vars" to all columns save "var_of_interest" and "rm"
      dependent_vars <- base::setdiff(x = base::setdiff(x = names(df), y = var_of_interest), y = rm)
    }

    ##########################################################################################################################
    # Second: if both "rm" and "dependent_vars" are NULL's, set "dependent_vars" to all other columns save "var_of_interest" #
    ##########################################################################################################################

    if (rlang::is_null(rm)) {
      dependent_vars <- base::setdiff(x = names(df), y = var_of_interest)
    }
  }

  ################################################################################
  # If the user supplies dependent variables to be crossed, check input validity #
  ################################################################################

  if (!rlang::is_null(dependent_vars)) {
    # Check dependent_vars type and size
    if (!is.character(dependent_vars) | length(dependent_vars) > (length(df) - 1)) {
      stop(
        "The argument 'dependent_vars' must be a character vector with length no greater than (length(df) - 1)",
        call. = FALSE
      )
    }
    # Check if dependent_vars are in 'df
    if (!all(dependent_vars %in% names(df))) {
      stop(
        "The argument 'dependent_vars' must be a subset of `base::setdiff(x = names(df), y = var_of_interest)`",
        call. = FALSE
      )
    }
    # Check 'rm' type and whether they exist in 'df
    if (!rlang::is_null(rm)) {
      if (!is.character(rm)) {
        stop("The argument 'rm' must be a character vector", call. = FALSE)
      }
      if (!all(rm %in% names(df))) {
        stop("The argument 'rm' must contain columns in 'df'", call. = FALSE)
      }
    }
  }

  # Broadcast variable of interest (a single character) to have the same length as the dependent variable vector
  vec_var_of_interest <- rep_len(x = var_of_interest, length.out = length(dependent_vars))

  tibble(
    "x" = vec_var_of_interest,
    "y" = dependent_vars,
    "caption" = paste(
      str_to_title(str_replace_all(vec_var_of_interest, "[^[:alnum:]]", " ")),
      sep = " by ",
      str_to_title(str_replace_all(dependent_vars, "[^[:alnum:]]", " "))
    )
  )
}

# Topline -----------------------------------------------------------------

#' Generate a list of topline arguments
#'
#' @description
#' This function is helper for `generate_tbls()`. It automatically generates a list of arguments to be
#' passed on to `generate_tbls()` for a given set of arguments. This may be useful when the number of
#' variables in a data frame is large, and there is a need to generate varying arguments efficiently.
#'
#' @param df A data frame or tibble.
#' @param var_of_interest A single string of the variable of interest. Defaults to `NULL`, which returns
#'   all variables in `df` unless `rm` is `NULL`.
#' @param rm A character vector of variables to be removed from consideration. Defaults to `NULL`.
#'
#' @return A list of arguments. If n tables were to be generated, this is a `tibble` with dimensions (n, 2).
#'
#' @seealso [generate_tbls()] for an example of a list of arguments.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Generate list of arguments
#' generate_topline_args(df, "var_of_interest")
#'
#' # Specified removal variables
#' rm <- c("col19", "col20")
#' generate_topline_args(df, "var_of_interest", rm)
#' }
generate_topline_args <- function(df, var_of_interest = NULL, rm = NULL) {
  if (!is.data.frame(df)) stop("'df' must be a data frame", call. = FALSE)

  #######################################################################
  # If no user-supplied "var_of_interest", default to using all columns #
  #######################################################################

  if (rlang::is_null(var_of_interest)) {

    ########################################################################
    # First case: if "var_of_interest" is null remove columns if specified #
    ########################################################################

    if (!rlang::is_null(rm)) {
      # If 'rm' is not NULL, "rm" must be a character vector
      if (!is.character(rm)) {
        stop("The argument 'rm' must be a character vector", call. = FALSE)
      }
      # If 'rm' is not NULL, check if "rm" is in "df"
      if (!all(rm %in% names(df))) {
        stop("The argument 'rm' must contain columns in 'df'", call. = FALSE)
      }
      # Set "var_of_interest" to all columns save "rm"
      var_of_interest <- base::setdiff(x = names(df), y = rm)
    }

    ####################################################################################################
    # Second case: if both "rm" and "var_of_interest" are NULL's, set "var_of_interest" to all columns #
    ####################################################################################################

    if (rlang::is_null(rm)) {
      var_of_interest <- names(df)
    }
  }

  ##########################################################
  # If user supplies a vector of variables, validate input #
  ##########################################################

  if (!rlang::is_null(var_of_interest)) {
    # Check var_of_interest type, size, and whether it exists in 'df'
    if (!is.character(var_of_interest) | length(var_of_interest) > length(df) | !all(var_of_interest %in% names(df))) {
      stop(
        "The argument 'var_of_interest' must be a character vector of column names found in 'df' with length no greater than length(df)",
        call. = FALSE
      )
    }
    # If 'rm' is not NULL, check 'rm' type and whether they exist in 'df
    if (!rlang::is_null(rm)) {
      if (!is.character(rm)) {
        stop("The argument 'rm' must be a character vector", call. = FALSE)
      }
      if (!all(rm %in% names(df))) {
        stop("The argument 'rm' must contain columns in 'df'", call. = FALSE)
      }
    }
  }

  tibble(
    "x" = var_of_interest,
    "caption" = str_to_title(str_replace_all(var_of_interest, "[^[:alnum:]]", " "))
  )
}
