# Two-way -----------------------------------------------------------------

ft_generate_xtab <- function(df, x, y, weight, caption) {

  # Keep only alphabets and numbers in column names
  x_name <- str_to_title(str_replace_all(x, "[^[:alnum:]]", " "))
  y_name <- str_to_title(str_replace_all(y, "[^[:alnum:]]", " "))

  xtab <- moe_crosstab_internal(df = df, x = x, y = y, weight = weight)
  setattr(xtab, "names", c(x_name, y_name, "Percent", "MOE", "Survey Total Percent"))[
    get(x_name) == "No", eval(x_name) := "11"
  ][
    , eval(x_name) := as.integer(as.character(get(x_name)))
  ]
  # Reorder feeling thermometers
  setorderv(xtab, cols = x_name)[, eval(x_name) := as.character(get(x_name))][
    get(x_name) == "11", eval(x_name) := "No"
  ]

  roll_x <- names(xtab)[[1]]
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
    colformat_char(j = 3, suffix = " %") %>%
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

# Three-way ---------------------------------------------------------------

ft_generate_xtab_3way <- function(df, x, y, z, weight, caption) {

  # Keep only alphabets and numbers in column names
  x_name <- str_to_title(str_replace_all(x, "[^[:alnum:]]", " "))
  y_name <- str_to_title(str_replace_all(y, "[^[:alnum:]]", " "))
  z_name <- str_to_title(str_replace_all(z, "[^[:alnum:]]", " "))

  xtab_3way <- moe_crosstab_3way_internal(df = df, x = x, y = y, z = z, weight = weight)
  setattr(xtab_3way, "names", c(z_name, x_name, y_name, "Percent", "MOE", "Survey Total Percent"))[
    get(z_name) == "No", eval(z_name) := "11"
  ][
    , eval(z_name) := as.integer(as.character(get(z_name)))
  ]
  # Reorder feeling thermometers
  setorderv(xtab_3way, cols = z_name)[, eval(z_name) := as.character(get(z_name))][
    get(z_name) == "11", eval(z_name) := "No"
  ]

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
