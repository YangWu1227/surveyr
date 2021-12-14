#' Generate crosstabs (latex)
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
#' @seealso [generate_xtab_docx()] for outputting to Microsoft word.
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
#' df %>% generate_xtab_latex(df = ., "x_var", "y_var", "weight", "X by Y")
#' }
generate_xtab_latex <- function(df, x, y, weight, caption) {
  if (!is.data.frame(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is.character(caption) | !length(caption) == 1) {
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
  while (length(levels) > 0) {
    # If, when dividing the length of the `levels` vector by 2, we get a remainder of 1, apply grey
    if (length(levels) %% 2 == 1) {
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
    } else if (length(levels) %% 2 == 0) {
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


#' Generate crosstabs (word)
#'
#' @description
#' This function takes a data frame or a tibble object, a few variables, and a string caption, returning
#' a list object that is an instance of class `flextable`. The function implements data masking internally
#' so users must specify data variables as strings (i.e. use "x", "y", "weight").
#'
#' @param df A data frame or tibble.
#' @param x A single string of the independent variable.
#' @param y A single string of the dependent variable.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the crosstab.
#'
#' @return A list object, which is an object of class `flextable`.
#'
#' @seealso [generate_xtab_latex()] for outputting to pdf.
#'
#' @importFrom officer fp_border
#' @importFrom flextable flextable
#' @importFrom flextable colformat_double
#' @importFrom flextable colformat_num
#' @importFrom flextable align
#' @importFrom flextable bold
#' @importFrom flextable color
#' @importFrom flextable font
#' @importFrom flextable bg
#' @importFrom flextable merge_v
#' @importFrom flextable vline_left
#' @importFrom flextable vline_right
#' @importFrom flextable hline_top
#' @importFrom flextable hline_bottom
#' @importFrom flextable set_caption
#' @importFrom flextable fix_border_issues
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a crosstab
#' df %>% generate_xtab_docx(df = ., "x_var", "y_var", "weight", "X by Y")
#' }
generate_xtab_docx <- function(df, x, y, weight, caption) {
  if (!is.data.frame(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is.character(caption) | !length(caption) == 1) {
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
      .at = 3,
      .f = round,
      digits = 1
    )

  roll_x <- names(xtab)[[1]]

  xtab_formatted <- xtab %>%
    flextable() %>%
    set_caption(caption = caption) %>%
    colformat_double(j = 5, digits = 0) %>%
    colformat_double(j = 4, digits = 1) %>%
    colformat_num(j = 3, suffix = " %") %>%
    align(align = "center", part = "header") %>%
    align(i = NULL, j = 3:5, align = "center", part = "body") %>%
    bold(bold = TRUE, part = "header") %>%
    bold(i = NULL, j = 1, bold = TRUE, part = "body") %>%
    font(fontname = "Open Sans", part = "all") %>%
    color(color = "white", part = "header") %>%
    bg(i = NULL, j = NULL, bg = "#32BDB9", part = "header") %>%
    merge_v(target = roll_x, part = "body") %>%
    vline_left(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    vline_right(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_top(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_bottom(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    fix_border_issues(part = "all")

  # Obtain a character vector of unique categories (factor levels)
  levels <- xtab[[1]] %>%
    unique() %>%
    as.character()

  while (length(levels) > 0) {
    if (length(levels) %% 2 == 1) {
      row_num <- which(xtab[[1]] == levels[[1]])
      xtab_formatted <- bg(x = xtab_formatted, i = row_num, j = NULL, bg = "#e5e5e5", part = "body")
    } else if (length(levels) %% 2 == 0) {
      row_num <- which(xtab[[1]] == levels[[1]])
      xtab_formatted <- bg(x = xtab_formatted, i = row_num, j = NULL, bg = "#FFFFFF", part = "body")
    }
    levels <- levels[-1]
  }

  # Return formatted table
  xtab_formatted
}
