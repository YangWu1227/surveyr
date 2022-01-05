# Exported function for multiselect with a 'parent' switch argument -------

#' Generate toplines for multiple selection questions (word)
#'
#' @description
#' This function generates a \emph{single} topline for cases where there is no \strong{parent} response column in the
#' multiselect question. These cases are organized such that each column in `df` represents a single choice
#' in a multiselect question. Alternatively, there may be cases where `df` is structured such that the
#' \strong{first} column represents a \strong{parent} of the multiselect question in addition to the \strong{choices}
#' or \strong{children} columns that represent the multiselect choices. In such cases, \emph{two} toplines will
#' be generated--- one for the parent response and another for the choices columns. Users may control the output
#' with the `parent` argument. Note that, for multiselect questions that involve a parent response column,
#' it is assumed that such a column is the first column of the argument `df`. Therefore, some pre-processing may be
#' needed to ensure that this requirement is met.
#'
#' @param df A data frame or data.table or tibble.
#' @param weight A single string of the weighting variable.
#' @param caption A length one character vector used as the caption for the topline.
#' @param parent A boolean indicating whether `df` has a parent response column. Defaults to `FALSE`.
#'
#' @return A list object containing a either one or two objects of class `flextable`.
#'
#' @seealso [apply_topline_multiselect()] for vectorized topline generation for multiple selection questions.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # Generate a topline (multiselect)
#' df %>%
#'   generate_topline_multiselect(
#'     df = .,
#'     "weight",
#'     "caption",
#'     FALSE
#'   )
#' }
generate_topline_multiselect <- function(df, weight, caption, parent = FALSE) {
  class(df) <- c("data.table", "data.frame")

  if (parent) {
    topline_multiselect_parent(df, weight, caption)
  } else if (!parent) {
    topline_multiselect(df, weight, caption)
  }
}

# Function for mutliselect with a parent table ----------------------------

topline_multiselect_parent <- function(df, weight, caption) {
  # Parent topline
  parent_var <- names(df)[[1]]
  topline_parent <- generate_topline_docx(df, x = parent_var, weight = weight, caption = caption[[1]])

  # Child topline
  df_child <- na.omit(df, cols = parent_var)[, c(parent_var) := NULL]
  cols <- setdiff(names(df_child), weight)

  # Count column frequency (sum of weight vector)
  col_frequency_list <- lapply(
    X = cols,
    # Subset rows based on each column to eliminate NA's, then sum the 'weight' column
    FUN = function(x) sum(na.omit(df_child, cols = x)[[weight]])
  )

  # Topline data
  topline_data <- data.table(
    Response = str_replace_all(cols, "[^[:alnum:]]", " "),
    Frequency = round(unlist(col_frequency_list), digits = 0),
    Percent = round(unlist(col_frequency_list) / sum(df_child[[weight]]) * 100, digits = 1)
  )
  # Add column totals
  topline_data <- rbindlist(list(
    topline_data,
    data.table(Response = "Total", Frequency = round(sum(df_child[[weight]]), digits = 0), Percent = NA)
  ))

  # Topline
  even <- seq_len(vec_size(topline_data)) %% 2 == 0
  odd <- !even

  topline_child <- topline_data |>
    flextable() |>
    set_caption(caption = caption[[2]]) |>
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

  parent_child_list <- list(topline_parent, topline_child)
  names(parent_child_list) <- c(eval(parent_var), eval(parent_var))

  parent_child_list
}

# Function for multiselect without a parent table -------------------------

topline_multiselect <- function(df, weight, caption) {
  cols <- setdiff(names(df), weight)
  # Count column frequency (sum of weight vector)
  col_frequency_list <- lapply(
    X = cols,
    # Subset rows based on each column to eliminate NA's, then sum the 'weight' column
    FUN = function(x) sum(na.omit(df, cols = x)[[weight]])
  )

  # Topline data
  topline_data <- data.table(
    Response = str_replace_all(cols, "[^[:alnum:]]", " "),
    Frequency = round(unlist(col_frequency_list), digits = 0),
    Percent = round(unlist(col_frequency_list) / sum(df[[weight]]) * 100, digits = 1)
  )
  # Add column totals
  topline_data <- rbindlist(list(
    topline_data,
    data.table(Response = "Total", Frequency = round(sum(df[[weight]]), digits = 0), Percent = NA)
  ))


  # Topline
  even <- seq_len(vec_size(topline_data)) %% 2 == 0
  odd <- !even

  topline <- topline_data |>
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

  topline_list <- list(no_parent = topline)

  topline_list
}
