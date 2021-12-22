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
#' @importFrom pollster moe_crosstab
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
  x_name <- str_to_title(str_replace_all(x, "[^[:alnum:]]", " "))
  y_name <- str_to_title(str_replace_all(y, "[^[:alnum:]]", " "))
  # Convert string to symbols
  x <- ensym(x)
  y <- ensym(y)
  weight <- ensym(weight)

  xtab <- as.data.table(moe_crosstab(df = df, x = {{ x }}, y = {{ y }}, weight = {{ weight }})) %>%
    setattr(x = ., "names", c(x_name, y_name, "Percent", "MOE", "N"))
  xtab[, c(x_name, y_name, "Percent", "MOE", "N") := .(
    str_wrap(get(x_name), width = 25),
    str_wrap(get(y_name), width = 25),
    paste(as.character(round(Percent, digits = 1)), "\\%"),
    as.character(round(MOE, digits = 1)),
    as.character(round(N, digits = 0))
  )]

  # First column of the crosstab
  first_column <- as.character(xtab[[1]])
  # Obtain a character vector of unique categories (factor levels)
  levels <- unique(first_column)

  invisible(lapply(
    X = levels,
    FUN = function(x) {
      row_num <- first_column == x
      color_index <- which(levels == x)
      if (color_index %% 2 == 1) {
        # Apply \makecell, \colorbox, and \cellcolor to rows whose indices are in 'row_num'
        # For the first two columns, also apply the associating linebreak function
        xtab[row_num, c(x_name, y_name, "Percent", "MOE", "N") := .(
          paste0("\\cellcolor[HTML]{ffffff}{", linebreak_white(get(x_name)), "}"),
          paste0("\\cellcolor[HTML]{ffffff}{", linebreak_white(get(y_name)), "}"),
          paste0("\\cellcolor[HTML]{ffffff}{", Percent, "}"),
          paste0("\\cellcolor[HTML]{ffffff}{", MOE, "}"),
          paste0("\\cellcolor[HTML]{ffffff}{", N, "}")
        )]
      } else if (color_index %% 2 == 0) {
        # Apply \makecell, \colorbox, and \cellcolor to rows whose indices are in 'row_num'
        # For the first two columns, also apply the associating linebreak function
        xtab[row_num, c(x_name, y_name, "Percent", "MOE", "N") := .(
          paste0("\\cellcolor[HTML]{e5e5e5}{", linebreak_grey(get(x_name)), "}"),
          paste0("\\cellcolor[HTML]{e5e5e5}{", linebreak_grey(get(y_name)), "}"),
          paste0("\\cellcolor[HTML]{e5e5e5}{", Percent, "}"),
          paste0("\\cellcolor[HTML]{e5e5e5}{", MOE, "}"),
          paste0("\\cellcolor[HTML]{e5e5e5}{", N, "}")
        )]
      }
    }
  ))

  # Create kableextra table object and format
  xtab_formatted <- xtab |>
    kbl(
      align = rep("l", times = 5),
      caption = caption,
      escape = FALSE,
      booktabs = FALSE,
      longtable = TRUE,
      position = "h",
      centering = TRUE,
      vline = "",
      linesep = c(rep("", times = vec_size(xtab)), "\\addlinespace")
    ) |>
    kable_styling(
      latex_options = c(
        "hold_position"
      ),
      font_size = 15
    ) |>
    row_spec(
      row = 0,
      bold = TRUE,
      color = "white",
      background = "#32bdb9"
    ) |>
    column_spec(
      column = 1,
      bold = TRUE,
      border_left = TRUE
    ) |>
    column_spec(
      column = 5,
      border_right = TRUE
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
  x_name <- str_to_title(str_replace_all(x, "[^[:alnum:]]", " "))
  y_name <- str_to_title(str_replace_all(y, "[^[:alnum:]]", " "))
  # Convert string to symbols
  x <- ensym(x)
  y <- ensym(y)
  weight <- ensym(weight)

  xtab <- as.data.table(moe_crosstab(df = df, x = {{ x }}, y = {{ y }}, weight = {{ weight }})) %>%
    setattr(x = ., "names", c(x_name, y_name, "Percent", "MOE", "N"))
  xtab[, c("Percent", "MOE", "N") := .(
    round(Percent, digits = 1),
    round(MOE, digits = 1),
    round(N, digits = 0)
  )]

  roll_x <- names(xtab)[[1]]

  xtab_formatted <- xtab %>%
    flextable() %>%
    set_caption(caption = caption) %>%
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

  # First column of the crosstab
  first_column <- as.character(xtab[[1]])
  # Obtain a character vector of unique categories (factor levels)
  levels <- unique(first_column)

  invisible(lapply(
    X = levels,
    FUN = function(x) {
      row_num <- first_column == x
      color_index <- which(levels == x)
      if (color_index %% 2 == 1) {
        xtab_formatted <<- bg(x = xtab_formatted, i = row_num, j = NULL, bg = "#FFFFFF", part = "body")
      } else if (color_index %% 2 == 0) {
        xtab_formatted <<- bg(x = xtab_formatted, i = row_num, j = NULL, bg = "#e5e5e5", part = "body")
      }
    }
  ))

  # Return formatted table
  xtab_formatted
}
