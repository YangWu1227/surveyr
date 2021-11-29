#' Generate toplines
#'
#' @description
#' This function takes a data frame or a tibble object, a variable of interest, and a string
#' caption, returning a length one character vector of the table source code. The function
#' implements data masking internally so users must specify data variables as strings
#' (i.e. use "x", "weight").
#'
#' @param df A data frame or tibble.
#' @param x A single string of variable name.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the topline.
#'
#' @return A character vector of the table source code, which is an object of class `knitr_kable`.
#'
#' @seealso [generate_xtab()] for crosstab generation.
#'
#' @importFrom dplyr select
#' @export
#'
#' @examples
#' # Generate a topline
#' df %>% generate_topline(df = ., "x_var", "weight", "X")
generate_topline <- function(df, x, weight, caption) {
  if (!"data.frame" %in% class(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is_character(caption, n = 1)) {
    stop("The argument 'caption' must be a length one character vector", call. = FALSE)
  }
  if (!is_character(x, n = 1) | !is_character(weight, n = 1)) {
    stop("The arguments 'x' and 'weight' must be character vectors of length one", call. = FALSE)
  }

  # Convert string to symbols
  x <- ensym(x)
  weight <- ensym(weight)

  topline <- pollster::topline(df = df, variable = {{ x }}, weight = {{ weight }}) %>%
    select(-c(Percent, `Cumulative Percent`)) %>%
    rename(
      Percent = `Valid Percent`
    ) %>%
    # Apply string wrap function to first two columns (which are both text columns)
    # This inserts "\n" into the strings every 25 characters
    modify_at(
      .x = .,
      .at = 1,
      .f = str_wrap,
      width = 25
    ) %>%
    modify_at(
      .x = .,
      .at = 2:3,
      .f = ~ round(.x, digits = 1)
    ) %>%
    modify(
      .x = .,
      .f = as.character
    )

  # Obtain a character vector of unique categories (factor levels)
  levels <- topline[[1]] %>%
    unique() %>%
    as.character()
  # Apply "grey" and "white" striping based on categories in levels
  # Keep executing expressions until we exhaust the levels vector
  while (vec_size(levels) > 0) {
    # If, when dividing the length of the levels vector by 2, we get a remainder of 1, apply grey
    if (vec_size(levels) %% 2 == 1) {
      # Create a vector of row index satisfying a particular category in "levels"
      row_num <- which(topline[[1]] == levels[[1]])
      # Only \makecell, \colorbox, and \cellcolorto rows whose indices are in 'row_num'
      topline[row_num, ] <- topline[row_num, ] %>%
        mutate(across(.cols = 1, .fns = linebreak_grey))
      # Apply \cellcolor to other cells in these rows
      topline[row_num, ] <- topline[row_num, ] %>% modify(
        .x = .,
        .f = ~ paste0("\\cellcolor[HTML]{e5e5e5}{", .x, "}")
      )
      # If, when dividing the length of the levels vector by 2, we get a remainder of 0, apply white
    } else if (vec_size(levels) %% 2 == 0) {
      # Create a vector of row index satisfying a particular category in "levels"
      row_num <- which(topline[[1]] == levels[[1]])
      # Only \makecell, \colorbox, and \cellcolor to rows whose indices are in 'row_num'
      topline[row_num, ] <- topline[row_num, ] %>%
        mutate(across(.cols = 1, .fns = linebreak_white))
      # Apply \cellcolor to other cells in these rows
      topline[row_num, ] <- topline[row_num, ] %>% modify(
        .x = .,
        .f = ~ paste0("\\cellcolor[HTML]{ffffff}{", .x, "}")
      )
    }
    # At the end of each iteration, remove a category and return control to top level
    levels <- levels[-1]
  }

  # Create kableextra table object and format
  topline_formatted <- topline %>%
    kbl(
      x = .,
      align = rep("l", times = 3),
      caption = caption,
      escape = FALSE,
      booktabs = FALSE,
      longtable = TRUE,
      position = "h",
      centering = TRUE,
      vline = "",
      linesep = c(rep("", times = vec_size(topline)), "\\addlinespace")
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
    ) %>%
    column_spec(
      column = 1,
      bold = TRUE
    )

  # Return formatted table
  topline_formatted
}
