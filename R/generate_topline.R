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
#' @importFrom pollster topline
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

  # Object of class data.table
  topline <- as.data.table(topline(df = df, variable = {{ x }}, weight = {{ weight }}))[
    , .(Response, Frequency, Percent = `Valid Percent`)
  ][, c(
    "Response",
    "Frequency",
    "Percent"
  ) := .(
    str_wrap(Response, width = 25),
    as.character(round(Frequency, digits = 1)),
    paste(round(Percent, digits = 1), "\\%")
  )]

  # Indices to apply background color
  even <- seq.int(length.out = vec_size(topline)) %% 2 == 0
  odd <- !even

  # Use reference semantics to modify in place
  topline[even, Response := linebreak_grey(Response)][even, c(
    "Response",
    "Frequency",
    "Percent"
  ) := .(
    paste0("\\cellcolor[HTML]{e5e5e5}{", Response, "}"),
    paste0("\\cellcolor[HTML]{e5e5e5}{", Frequency, "}"),
    paste0("\\cellcolor[HTML]{e5e5e5}{", Percent, "}")
  )][odd, Response := linebreak_white(Response)][odd, c(
    "Response",
    "Frequency",
    "Percent"
  ) := .(
    paste0("\\cellcolor[HTML]{ffffff}{", Response, "}"),
    paste0("\\cellcolor[HTML]{ffffff}{", Frequency, "}"),
    paste0("\\cellcolor[HTML]{ffffff}{", Percent, "}")
  )]

  # Create kableextra table object and format
  topline_formatted <- topline |>
    kbl(
      align = rep("l", times = 3),
      caption = caption,
      escape = FALSE,
      booktabs = FALSE,
      longtable = TRUE,
      position = "h",
      centering = TRUE,
      vline = "",
      linesep = c(rep("", times = vec_size(topline)), "\\addlinespace")
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
#' @import data.table
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

  topline <- as.data.table(topline(df = df, variable = {{ x }}, weight = {{ weight }}))[
    , .(Response, Frequency, Percent = `Valid Percent`)
  ][, c("Frequency", "Percent") := .(
    round(Frequency, digits = 0),
    round(Percent, digits = 1)
  )]

  # Row indices to apply zebra-stripe
  even <- seq.int(length.out = vec_size(topline)) %% 2 == 0
  odd <- !even

  topline_formatted <- topline |>
    flextable() |>
    set_caption(caption = caption) |>
    colformat_num(j = 3, suffix = " %") |>
    align(align = "center", part = "header") |>
    align(i = NULL, j = 2:3, align = "center", part = "body") |>
    bold(bold = TRUE, part = "header") |>
    bold(i = NULL, j = 1, bold = TRUE, part = "body") |>
    font(fontname = "Open Sans", part = "all") |>
    color(color = "white", part = "header") |>
    bg(i = NULL, j = NULL, bg = "#32BDB9", part = "header") |>
    vline_left(border = fp_border(color = "black", style = "solid", width = 1), part = "all") |>
    vline_right(border = fp_border(color = "black", style = "solid", width = 1), part = "all") |>
    hline_top(border = fp_border(color = "black", style = "solid", width = 1), part = "all") |>
    hline_bottom(border = fp_border(color = "black", style = "solid", width = 1), part = "all") |>
    fix_border_issues(part = "all") |>
    bg(i = even, bg = "#e5e5e5", part = "body") |>
    bg(i = odd, bg = "#FFFFFF", part = "body")

  # Return formatted table
  topline_formatted
}
