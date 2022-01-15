# Word --------------------------------------------------------------------

ft_generate_topline <- function(df, x, weight, caption) {

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

