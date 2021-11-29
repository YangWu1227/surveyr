#' Generate crosstabs
#'
#' @description
#' This function takes a data frame or a tibble object, a few variables, and a string caption, returning
#' a length one character vector of the table source code. The function implements data masking internally
#' so users must specify data variables as strings (i.e. use "x", "y", "weight").
#'
#' @param df A data frame or tibble.
#' @param x A single string of the independent variable.
#' @param y A single string of the dependent variable.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the crosstab.
#'
#' @return A character vector of the table source code, which is an object of class `knitr_kable`.
#'
#' @seealso [generate_topline()] for topline generation.
#'
#' @importFrom magrittr %>%
#' @importFrom kableExtra kbl
#' @importFrom kableExtra kable_styling
#' @importFrom kableExtra row_spec
#' @importFrom kableExtra column_spec
#' @importFrom rlang is_character
#' @importFrom rlang ensym
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_wrap
#' @importFrom purrr modify_at
#' @importFrom purrr modify
#' @importFrom dplyr rename
#' @importFrom dplyr mutate
#' @importFrom dplyr across
#' @importFrom vctrs vec_size
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a crosstab
#' df %>% generate_xtab(df = ., "x_var", "y_var", "weight", "X by Y")
#' }
generate_xtab <- function(df, x, y, weight, caption) {
  if (!"data.frame" %in% class(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is_character(caption, n = 1)) {
    stop("The argument 'caption' must be a length one character vector", call. = FALSE)
  }
  if (!is_character(x, n = 1) |
    !is_character(y, n = 1) |
    !is_character(weight, n = 1)) {
    stop("The arguments 'x', 'y', and 'weight' must be character vectors of length one", call. = FALSE)
  }

  # Keep only alphabets and numbers in column names
  x_name <- str_replace_all(x, "[^[:alnum:]]", " ")
  y_name <- str_replace_all(y, "[^[:alnum:]]", " ")
  # Convert string to symbols
  x <- ensym(x)
  y <- ensym(y)
  weight <- ensym(weight)

  xtab <- pollster::moe_crosstab(df = df, x = {{ x }}, y = {{ y }}, weight = {{ weight }}) %>%
    rename(
      Percent = pct,
      MOE = moe,
      N = n,
      {{ x_name }} := {{ x }},
      {{ y_name }} := {{ y }}
    ) %>%
    modify_at(
      .x = .,
      .at = 1:2,
      .f = str_wrap,
      width = 25
    ) %>%
    modify_at(
      .x = .,
      .at = 3:4,
      .f = ~ round(.x, digits = 1)
    ) %>%
    modify_at(
      .x = .,
      .at = 5,
      .f = ~ round(.x, digits = 0)
    ) %>%
    modify(
      .x = .,
      .f = as.character
    )

  # Obtain a character vector of unique categories (factor levels)
  levels <- xtab[[1]] %>%
    unique() %>%
    as.character()
  # Apply "grey" and "white" row color based on categories in levels
  # Keep executing expressions until we exhaust the levels vector
  while (vec_size(levels) > 0) {
    # If, when dividing the length of the `levels` vector by 2, we get a remainder of 1, apply grey
    if (vec_size(levels) %% 2 == 1) {
      # Create a vector of row index satisfying a particular category in "levels"
      row_num <- which(xtab[[1]] == levels[[1]])
      # Apply \makecell, \colorbox, and \cellcolor to rows whose indices are in 'row_num'
      xtab[row_num, ] <- xtab[row_num, ] %>%
        mutate(across(.cols = 1:2, .fns = linebreak_grey))
      # Apply \cellcolor to all cells in these rows
      xtab[row_num, ] <- xtab[row_num, ] %>% modify(
        .x = .,
        .f = ~ paste0("\\cellcolor[HTML]{e5e5e5}{", .x, "}")
      )
      # If, when dividing the length of the levels vector by 2, we get a remainder of 0, apply white
    } else if (vec_size(levels) %% 2 == 0) {
      # Create a vector of row index satisfying a particular category in "levels"
      row_num <- which(xtab[[1]] == levels[[1]])
      # Apply \makecell, \colorbox, and \cellcolor to rows whose indices are in 'row_num'
      xtab[row_num, ] <- xtab[row_num, ] %>%
        mutate(across(.cols = 1:2, .fns = linebreak_white))
      # Apply \cellcolor to all cells in these rows
      xtab[row_num, ] <- xtab[row_num, ] %>% modify(
        .x = .,
        .f = ~ paste0("\\cellcolor[HTML]{ffffff}{", .x, "}")
      )
    }
    # At the end of each iteration, remove a category and return control to top level
    levels <- levels[-1]
  }

  # Create kableextra table object and format
  xtab_formatted <- xtab %>%
    kbl(
      x = .,
      digits = c(0, 0, 0, 0, 0),
      align = rep("l", times = 5),
      caption = caption,
      escape = FALSE,
      booktabs = FALSE,
      longtable = TRUE,
      position = "h",
      centering = TRUE,
      vline = "",
      linesep = c(rep("", times = vec_size(xtab)), "\\addlinespace")
    ) %>%
    kable_styling(
      kable_input = .,
      latex_options = c(
        "hold_position"
      ),
      font_size = 15
    ) %>%
    row_spec(
      row = 0,
      bold = TRUE,
      color = "white",
      background = "#32bdb9"
    )

  # Return formatted table
  xtab_formatted
}
