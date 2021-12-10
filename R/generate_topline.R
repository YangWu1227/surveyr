#' Generate toplines (latex)
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
#' @seealso [generate_topline_docx()] for outputting to Microsoft word.
#'
#' @importFrom dplyr select
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a topline
#' df %>% generate_topline_latex(df = ., "x_var", "weight", "X")
#' }
generate_topline_latex <- function(df, x, weight, caption) {
  if (!is.data.frame(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is.character(caption) | !length(caption) == 1) {
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
  while (length(levels) > 0) {
    # If, when dividing the length of the levels vector by 2, we get a remainder of 1, apply grey
    if (length(levels) %% 2 == 1) {
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
    } else if (length(levels) %% 2 == 0) {
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


#' Generate toplines (word)
#'
#' @description
#' This function takes a data frame or a tibble object, a variable of interest, and a string
#' caption, returning a list object that is an instance of class `flextable`. The function
#' implements data masking internally so users must specify data variables as strings
#' (i.e. use "x", "weight").
#'
#' @param df A data frame or tibble.
#' @param x A single string of variable name.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the topline.
#'
#' @return A list object, which is an object of class `flextable`.
#'
#' @seealso [generate_topline_latex()] for outputting to pdf.
#'
#' @importFrom dplyr select
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a topline
#' df %>% generate_topline_docx(df = ., "x_var", "weight", "X")
#' }
generate_topline_docx <- function(df, x, weight, caption) {
  if (!is.data.frame(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is.character(caption) | !length(caption) == 1) {
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
    )

  topline_formatted <- topline %>%
    flextable() %>%
    set_caption(caption = caption) %>%
    colformat_double(j = 2:3, digits = 1) %>%
    align(align = "center", part = "header") %>%
    align(i = NULL, j = 2:3, align = "center", part = "body") %>%
    bold(bold = TRUE, part = "header") %>%
    bold(i = NULL, j = 1, bold = TRUE, part = "body") %>%
    font(fontname = "Open Sans", part = "all") %>%
    color(color = "white", part = "header") %>%
    bg(i = NULL, j = NULL, bg = "#32BDB9", part = "header") %>%
    vline_left(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    vline_right(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_top(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_bottom(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    fix_border_issues(part = "all")

  # Obtain a character vector of unique categories (factor levels)
  levels <- topline[[1]] %>%
    unique() %>%
    as.character()

  while (length(levels) > 0) {
    if (length(levels) %% 2 == 1) {
      row_num <- which(topline[[1]] == levels[[1]])
      topline_formatted <- bg(x = topline_formatted, i = row_num, j = NULL, bg = "#e5e5e5", part = "body")
    } else if (length(levels) %% 2 == 0) {
      row_num <- which(topline[[1]] == levels[[1]])
      topline_formatted <- bg(x = topline_formatted, i = row_num, j = NULL, bg = "#FFFFFF", part = "body")
    }
    levels <- levels[-1]
  }

  # Return formatted table
  topline_formatted
}
