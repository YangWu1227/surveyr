#' Generate crosstabs
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
#' @seealso [generate_xtab_3way()] for three-way crosstabs.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang is_character
#' @importFrom rlang ensym
#' @importFrom stringr str_replace_all
#' @importFrom stringr str_wrap
#' @importFrom dplyr rename
#' @importFrom dplyr mutate
#' @importFrom vctrs vec_size
#' @importFrom officer fp_border
#' @importFrom flextable flextable
#' @importFrom flextable colformat_double
#' @importFrom flextable colformat_char
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
#' df %>% generate_xtab(df = ., "x_var", "y_var", "weight", "X by Y")
#' }
generate_xtab <- function(df, x, y, weight, caption) {
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

  xtab <- moe_crosstab_internal(df = df, x = x, y = y, weight = weight) %>%
    setattr("names", c(x_name, y_name, "Percent", "MOE", "Survey Total Percent"))

  roll_x <- names(xtab)[[1]]
  # First column of the crosstab
  first_column <- as.character(xtab[[1]])
  # Obtain a character vector of unique categories (factor levels)
  levels <- unique(first_column)

  # Initialize container
  stripe_index_container <- logical(length = length(first_column))
  # Stripe index
  invisible(lapply(
    X = levels,
    FUN = function(x) {
      row_num <- first_column == x
      level_index <- which(levels == x)
      if (level_index %% 2 == 0) {
        stripe_index_container[row_num] <<- rep.int(TRUE, times = sum(row_num))
      } else if (level_index %% 2 == 1) {
        stripe_index_container[row_num] <<- rep.int(FALSE, times = sum(row_num))
      }
    }
  ))

  xtab_formatted <- xtab %>%
    flextable() %>%
    set_caption(caption = caption) %>%
    colformat_char(j = c(3, 5), suffix = " %") %>%
    align(align = "center", part = "header") %>%
    align(i = NULL, j = 3:5, align = "center", part = "body") %>%
    bold(bold = TRUE, part = "header") %>%
    bold(i = NULL, j = 1, bold = TRUE, part = "body") %>%
    font(fontname = "Open Sans", part = "all") %>%
    color(color = "white", part = "header") %>%
    bg(i = NULL, j = NULL, bg = "#32BDB9", part = "header") %>%
    bg(i = stripe_index_container, j = NULL, bg = "#e5e5e5", part = "body") %>%
    merge_v(j = roll_x, target = roll_x, part = "body") %>%
    vline_left(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    vline_right(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_top(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_bottom(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    fix_border_issues(part = "all")

  # Return formatted table
  xtab_formatted
}


#' Generate three-way crosstabs
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' This function takes a data frame or a tibble object, a few variables, and a string caption, returning
#' a list object that is an instance of class `flextable`. The function implements data masking internally
#' so users must specify data variables as strings (i.e. use "x", "y", "z", "weight").
#'
#' @param df A data frame or tibble.
#' @param x A single string of the independent variable.
#' @param y A single string of the dependent variable.
#' @param z A single string of the control variable.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the crosstab.
#'
#' @return A list object, which is an object of class `flextable`.
#'
#' @seealso [generate_xtab_word()] for two-way crosstabs.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a crosstab
#' df %>% generate_xtab_3way(df = ., "x_var", "y_var", "z_var", "weight", "Z by X And Y")
#' }
generate_xtab_3way <- function(df, x, y, z, weight, caption) {
  if (!is.data.frame(df)) {
    stop("The argument 'df' must be an object of class or subclass of data frame", call. = FALSE)
  }
  if (!is.character(caption) | !length(caption) == 1) {
    stop("The argument 'caption' must be a length one character vector", call. = FALSE)
  }
  if (!is_character(x, n = 1) |
    !is_character(y, n = 1) |
    !is_character(z, n = 1) |
    !is_character(weight, n = 1)) {
    stop("The arguments 'x', 'y', 'z', and 'weight' must be character vectors of length one", call. = FALSE)
  }

  # Keep only alphabets and numbers in column names
  x_name <- str_to_title(str_replace_all(x, "[^[:alnum:]]", " "))
  y_name <- str_to_title(str_replace_all(y, "[^[:alnum:]]", " "))
  z_name <- str_to_title(str_replace_all(z, "[^[:alnum:]]", " "))

  xtab_3way <- moe_crosstab_3way_internal(df = df, x = x, y = y, z = z, weight = weight) %>%
    setattr("names", c(z_name, x_name, y_name, "Percent", "MOE", "Survey Total Percent"))

  roll_var <- names(xtab_3way)[[1]]
  # First column of the crosstab
  first_column <- as.character(xtab_3way[[1]])
  # Obtain a character vector of unique categories (factor levels)
  levels <- unique(first_column)

  # Initialize container
  stripe_index_container <- logical(length = length(first_column))
  # Stripe index
  invisible(lapply(
    X = levels,
    FUN = function(x) {
      row_num <- first_column == x
      level_index <- which(levels == x)
      if (level_index %% 2 == 0) {
        stripe_index_container[row_num] <<- rep.int(TRUE, times = sum(row_num))
      } else if (level_index %% 2 == 1) {
        stripe_index_container[row_num] <<- rep.int(FALSE, times = sum(row_num))
      }
    }
  ))

  xtab_3way_formatted <- xtab_3way %>%
    flextable() %>%
    set_caption(caption = caption) %>%
    colformat_char(j = 4, suffix = " %") %>%
    align(align = "center", part = "header") %>%
    align(i = NULL, j = 4:6, align = "center", part = "body") %>%
    bold(bold = TRUE, part = "header") %>%
    bold(i = NULL, j = 1, bold = TRUE, part = "body") %>%
    font(fontname = "Open Sans", part = "all") %>%
    color(color = "white", part = "header") %>%
    bg(i = NULL, j = NULL, bg = "#32BDB9", part = "header") %>%
    bg(i = stripe_index_container, j = NULL, bg = "#e5e5e5", part = "body") %>%
    merge_v(j = roll_var, target = roll_var, part = "body") %>%
    vline_left(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    vline_right(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_top(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    hline_bottom(border = fp_border(color = "black", style = "solid", width = 1), part = "all") %>%
    fix_border_issues(part = "all")

  # Return formatted table
  xtab_3way_formatted
}
