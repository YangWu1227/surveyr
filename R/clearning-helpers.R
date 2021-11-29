#' Remove special characters from selected columns
#'
#' @description
#' This function takes a data frame or a tibble object and a vector of columns, removing special
#' characters from the specified columns in the data frame or tibble. To be precise, the function
#' is implemented such that only the character class of numbers and letters in the current locale,
#' i.e., `[:alnum:]`, and periods (".") are retained.
#'
#' @param df A data frame or tibble.
#' @param var A character vector, with length no greater than `length(df)`, specifying the columns
#' from which special characters are to be removed.
#'
#' @return
#' An object of the same type as `df` with specified columns stripped of their special characters.
#'
#' @seealso [col_nms_rm_spl_char()] for removing special characters from columns names.
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr everything
#' @export
#' @examples
#' # Remove special characters from columns 1 & 2
#' df %>% rm_spl_char(var = c("col_1", "col_2"))
#'
#' # Remove special characters from all columns
#' cols <- names(df)
#' df %>% rrm_spl_char(var = cols)
rm_spl_char <- function(df, var) {
  if (is.data.frame(df) == FALSE) {
    stop("'df' must be a data frame", call. = FALSE)
  }
  if (!is_character(var) | vec_size(var) > length(df)) {
    stop("'var' must be a character vector no greater than `length(df)`", call. = FALSE)
  }
  if (!all(var %in% names(df))) {
    stop("'var' must be columns found in 'df'", call. = FALSE)
  }

  df[var] <- df[var] %>%
    mutate(
      across(
        .cols = everything(),
        .fns = ~ str_replace_all(.x, "[^[:alnum:]^.]", " ")
      )
    )

  df
}

#' Capitalize column names
#'
#' @description
#' Convert column names in a data frame to title cases.
#'
#' @param df A data frame or tibble.
#'
#' @return A data frame or tibble.
#'
#' @importFrom data.table setnames
#' @importFrom stringr str_to_title
#' @export
#'
#' @examples
#' # Capitalize column names
#' new_df <- col_nms_to_title(df)
col_nms_to_title <- function(df) {
  if (!is.data.frame(df)) {
    stop("'df' must be a data frame", call. = FALSE)
  }

  new_df <- setnames(
    x = df,
    old = names(df),
    new = str_to_title(string = names(df))
  )
  new_df
}

#' Remove special characters column names
#'
#' @description
#' Remove special characters from column names in a data frame. To be precise, the function
#' is implemented such that only the character class of numbers and letters in the current locale,
#' i.e., `[:alnum:]` is retained.
#'
#' @param df A data frame or tibble.
#'
#' @return A data frame or tibble.
#'
#' @seealso [rm_spl_char()] for removing special characters from selected columns.
#'
#' @export
#'
#' @examples
#' # Remove special characters from column names
#' new_df <- col_nms_rm_splchar(df)
col_nms_rm_splchar <- function(df) {
  if (!is.data.frame(df)) {
    stop("'df' must be a data frame", call. = FALSE)
  }

  new_df <- setnames(
    x = df,
    old = names(df),
    new = str_replace_all(names(df), "[^[:alnum:]]", " ")
  )
  new_df
}
