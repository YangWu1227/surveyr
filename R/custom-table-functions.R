#' @importFrom dplyr summarize
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr first
#' @importFrom dplyr add_row
#' @importFrom dplyr filter
#' @importFrom labelled to_factor
#' @importFrom forcats fct_explicit_na
topline_internal <- function(df, variable, weight) {
  d.output <- df |>
    # Convert to ordered factors
    mutate(
      {{ variable }} := to_factor({{ variable }}, sort_levels = "values"),
      {{ variable }} := fct_explicit_na({{ variable }})
    ) |>
    # Calculate denominator
    mutate(valid.total = sum(({{ weight }})[{{ variable }} != "(Missing)"])) |>
    # Calculate proportions
    group_by({{ variable }}) |>
    # Use first() to get the first value since 'valid.total' is a column (vector) where all values are the same
    summarize(
      Percent = round((sum({{ weight }}) / first(valid.total) * 100), digits = 1),
      n = round(sum({{ weight }}), digits = 0)
    ) |>
    ungroup() |>
    select(Response = {{ variable }}, Frequency = n, Percent) |>
    filter(Response != "(Missing)")

  # Column sums
  freq_sum <- sum(d.output[["Frequency"]])
  per_sum <- sum(d.output[["Percent"]])

  d.output <- add_row(d.output, Response = "Total", Frequency = freq_sum, Percent = per_sum)

  as.data.table(d.output)
}


#' @importFrom pollster deff_calc
#' @importFrom pollster moedeff_calc
#' @importFrom dplyr pull
#' @importFrom dplyr relocate
moe_crosstab_internal <- function(df, x, y, weight) {

  # calculate the design effect
  deff <- df |>
    pull({{ weight }}) |>
    deff_calc()

  # build the table, either row percents or cell percents
  d.output <- df |>
    filter(
      !is.na({{ x }}),
      !is.na({{ y }})
    ) |>
    mutate(
      {{ x }} := to_factor({{ x }}),
      {{ y }} := to_factor({{ y }})
    ) |>
    group_by({{ x }}) |>
    mutate(
      total = sum({{ weight }}),
      unweighted_n = length({{ weight }})
    ) |>
    group_by({{ x }}, {{ y }}) |>
    summarize(
      observations = sum({{ weight }}),
      Percent = observations / first(total),
      N = as.character(round(first(total), digits = 0)),
      unweighted_n = first(unweighted_n)
    ) |>
    ungroup() |>
    mutate(MOE = as.character(round(moedeff_calc(pct = Percent, deff = deff, n = unweighted_n, zscore = 1.96), digits = 1))) |>
    mutate(
      Percent = as.character(round(Percent * 100, digits = 1))
    ) |>
    select(-c("observations", "unweighted_n")) |>
    relocate(N, .after = MOE)

  as.data.table(d.output)
}
