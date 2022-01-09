# Word --------------------------------------------------------------------

ft_generate_topline_docx <- function(df, x, weight, caption) {

  # Convert string to symbols
  x <- ensym(x)
  weight <- ensym(weight)

  topline <- topline_internal(df = df, variable = {{ x }}, weight = {{ weight }})[
    Response == "No", Response := "11"
  ][
    Response == "Total", Response := "12"
  ][
    , Response := as.integer(Response)
  ]
  # Reorder feeling thermometers
  setorder(topline, Response)[, Response := as.character(Response)][
    Response == "11", Response := "No"
  ][
    Response == "12", Response := "Total"
  ]

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

# Latex -------------------------------------------------------------------

ft_generate_topline_latex <- function(df, x, weight, caption) {

  # Convert string to symbols
  x <- ensym(x)
  weight <- ensym(weight)

  # Object of class data.table
  topline <- topline_internal(df = df, variable = {{ x }}, weight = {{ weight }})[
    , c(
      "Frequency",
      "Percent"
    ) := .(
      as.character(Frequency),
      paste(Percent, "%")
    )
  ][
    Response == "No", Response := "11"
  ][
    Response == "Total", Response := "12"
  ][
    , Response := as.integer(Response)
  ]
  # Reorder feeling thermometers
  setorder(topline, Response)[, Response := as.character(Response)][
    Response == "11", Response := "No"
  ][
    Response == "12", Response := "Total"
  ]

  # Create kableextra table object and format
  topline_formatted <- topline %>%
    kbl(
      align = rep("l", times = 3),
      caption = caption,
      escape = TRUE,
      booktabs = FALSE,
      longtable = TRUE,
      position = "h",
      centering = TRUE,
      vline = "",
      linesep = c(rep("", times = vec_size(topline)), "\\addlinespace")
    ) %>%
    kable_styling(
      "striped",
      latex_options = c(
        "hold_position"
      ),
      font_size = 15,
      stripe_color = "#e5e5e5"
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
