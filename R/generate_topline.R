#' Generate toplines
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
#' @importFrom dplyr select
#' @import data.table
#' @importFrom flextable colformat_num
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a topline
#' df %>% generate_topline(df = ., "x_var", "weight", "X")
#' }
generate_topline <- function(df, x, weight, caption) {
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

  topline <- topline_internal(df = df, variable = {{ x }}, weight = {{ weight }})

  # Row indices to apply zebra-stripe
  even <- seq.int(length.out = vec_size(topline)) %% 2 == 0
  odd <- !even

  topline_formatted <- topline %>%
    flextable() %>%
    set_caption(caption = caption) %>%
    colformat_num(j = 3, suffix = " %") %>%
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
    fix_border_issues(part = "all") %>%
    bg(i = even, bg = "#e5e5e5", part = "body") %>%
    bg(i = odd, bg = "#FFFFFF", part = "body")

  # Return formatted table
  topline_formatted
}
