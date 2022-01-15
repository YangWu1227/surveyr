# Custom topline ----------------------------------------------------------

#' @importFrom dplyr summarize
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr first
#' @importFrom dplyr add_row
#' @importFrom dplyr filter
#' @importFrom labelled to_factor
#' @importFrom forcats fct_explicit_na
topline_internal <- function(df, variable, weight) {
  topline <- df %>%
    # Convert to ordered factors
    mutate(
      {{ variable }} := to_factor({{ variable }}, sort_levels = "values"),
      {{ variable }} := fct_explicit_na({{ variable }})
    ) %>%
    # Calculate denominator
    mutate(valid.total = sumcpp(({{ weight }})[{{ variable }} != "(Missing)"])) %>%
    # Calculate proportions
    group_by({{ variable }}) %>%
    # Use first() to get the first value since 'valid.total' is a column (vector) where all values are the same
    summarize(
      Percent = round((sumcpp({{ weight }}) / first(valid.total) * 100), digits = 1),
      n = round(sumcpp({{ weight }}), digits = 0)
    ) %>%
    ungroup() %>%
    select(Response = {{ variable }}, Frequency = n, Percent) %>%
    filter(Response != "(Missing)")

  # Column sums
  freq_sum <- sum(topline[["Frequency"]])
  per_sum <- sum(topline[["Percent"]])

  topline <- add_row(topline, Response = "Total", Frequency = freq_sum, Percent = per_sum)

  class(topline) <- c("data.table", "data.frame")
  topline
}

# Custom two-way crosstab -------------------------------------------------

#' @importFrom pollster deff_calc
#' @importFrom pollster moedeff_calc
#' @importFrom dplyr pull
#' @importFrom dplyr relocate
moe_crosstab_internal <- function(df, x, y, weight) {

  # Calculate the design effect
  deff <- df %>%
    pull({{ weight }}) %>%
    deff_calc()

  # Build the table, either row percents or cell percents
  xtab <- df %>%
    filter(
      !is.na({{ x }}),
      !is.na({{ y }})
    ) %>%
    mutate(
      {{ x }} := to_factor({{ x }}),
      {{ y }} := to_factor({{ y }})
    ) %>%
    group_by({{ x }}) %>%
    mutate(
      total = sumcpp({{ weight }}),
      unweighted_n = length({{ weight }})
    ) %>%
    group_by({{ x }}, {{ y }}) %>%
    summarize(
      observations = sumcpp({{ weight }}),
      Percent = observations / first(total),
      N = as.character(round(first(total), digits = 0)),
      unweighted_n = first(unweighted_n)
    ) %>%
    ungroup() %>%
    mutate(MOE = as.character(round(moedeff_calc(pct = Percent, deff = deff, n = unweighted_n, zscore = 1.96), digits = 1))) %>%
    mutate(
      Percent = as.character(round(Percent * 100, digits = 1))
    ) %>%
    select(-c("observations", "unweighted_n")) %>%
    relocate(N, .after = MOE)

  class(xtab) <- c("data.table", "data.frame")
  xtab
}

# Custom three-way crosstab -----------------------------------------------

moe_crosstab_3way_internal <- function(df, x, y, z, weight) {

  # Calculate the design effect
  deff <- df %>%
    pull({{ weight }}) %>%
    deff_calc()

  # Build the table, either row percents or cell percents
  xtab_3way <- df %>%
    filter(
      !is.na({{ x }}),
      !is.na({{ y }}),
      !is.na({{ z }})
    ) %>%
    mutate(
      {{ x }} := to_factor({{ x }}),
      {{ y }} := to_factor({{ y }}),
      {{ z }} := to_factor({{ z }})
    ) %>%
    group_by({{ z }}, {{ x }}) %>%
    mutate(
      total = sum({{ weight }}),
      unweighted_n = length({{ weight }})
    ) %>%
    group_by({{ z }}, {{ x }}, {{ y }}) %>%
    summarize(
      observations = sum({{ weight }}),
      Percent = observations / first(total),
      N = as.character(round(first(total), digits = 0)),
      unweighted_n = first(unweighted_n)
    ) %>%
    ungroup() %>%
    mutate(MOE = as.character(round(moedeff_calc(pct = Percent, deff = deff, n = unweighted_n, zscore = 1.96), digits = 1))) %>%
    mutate(Percent = as.character(round(Percent * 100, digits = 1))) %>%
    select(-c("observations", "unweighted_n")) %>%
    relocate(N, .after = MOE)

  class(xtab_3way) <- c("data.table", "data.frame")
  xtab_3way
}
