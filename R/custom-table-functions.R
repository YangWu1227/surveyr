# Custom topline ----------------------------------------------------------

#' @importFrom labelled to_factor
#' @importFrom forcats fct_explicit_na
topline_internal <- function(df, variable, weight) {
  df <- as.data.table(df)
  topline <- df[, eval(variable) := {
    var <- to_factor(get(variable), sort_levels = "values")
    var <- fct_explicit_na(var)
    .(var)
  }][, valid_total := {
    sumcpp(get(weight)[get(variable) != "(Missing)"])
  }][, .(
    Percent = round((sumcpp(get(weight)) / first(valid_total) * 100), digits = 1),
    Frequency = round(sumcpp(get(weight)), digits = 0)
  ),
  keyby = .(get(variable))
  ][get != "(Missing)"]

  setnames(topline, c("get", "Frequency", "Percent"), c("Response", "Frequency", "Percent"))
  setcolorder(topline, c("Response", "Frequency", "Percent"))

  topline <- rbindlist(list(topline, data.table(
    Response = "Total",
    Frequency = sum(topline$Frequency),
    Percent = sum(topline$Percent)
  )))[, Response := as.character(Response)]

  topline
}

# Custom two-way crosstab -------------------------------------------------

#' @importFrom pollster deff_calc
#' @importFrom pollster moedeff_calc
moe_crosstab_internal <- function(df, x, y, weight) {
  df <- as.data.table(df)
  deff <- deff_calc(df[, get(weight)])

  xtab <- df[!is.na(get(x)) & !is.na(get(y))][, c(x, y) := .(
    to_factor(get(x)),
    to_factor(get(y))
  )][, c("total", "unweighted_n") := .(
    sum(get(weight)),
    length(get(weight))
  ), by = eval(x)][, .(
    observations = sumcpp(get(weight)),
    N = first(total),
    unweighted_n = first(unweighted_n)
  ),
  keyby = .(get(x), get(y))
  ][, Percent := observations / N][, `:=`(MOE = as.character(round(
    moedeff_calc(pct = Percent, deff = ..deff, n = unweighted_n, zscore = 1.96),
    digits = 1
  )))][, `:=`(Percent = as.character(round(Percent * 100, digits = 1)))][, .(get, get.1, Percent, MOE)]

  lookup_tbl <- df[, eval(y) := {
    var <- to_factor(get(y), sort_levels = "values")
    var <- forcats::fct_explicit_na(var)
    .(var)
  }][, `:=`(valid_total = sum(get(weight)[get(y) != "(Missing)"]))][, .(Percent = round((sum(get(weight)) / first(valid_total) * 100), digits = 1)),
    keyby = .(get(y))
  ][eval(y) != "(Missing)"]
  lookup <- lookup_tbl$Percent
  names(lookup) <- lookup_tbl$get

  xtab[, `Survey Total Percent` := as.character(lookup[get.1])]

  setattr(xtab, "names", c(x, y, "Percent", "MOE", "Survey Total Percent"))

  xtab
}

# Custom three-way crosstab -----------------------------------------------

moe_crosstab_3way_internal <- function(df, x, y, z, weight) {
  df <- as.data.table(df)
  deff <- deff_calc(df[, get(weight)])

  xtab_3way <- df[!is.na(get(x)) & !is.na(get(y)) & !is.na(get(z))][, c(x, y, z) := .(
    to_factor(get(x)),
    to_factor(get(y)),
    to_factor(get(z))
  )][, c("total", "unweighted_n") := .(
    sum(get(weight)),
    length(get(weight))
  ), by = .(get(z), get(x))][, .(
    observations = sumcpp(get(weight)),
    N = first(total),
    unweighted_n = first(unweighted_n)
  ),
  keyby = .(get(z), get(x), get(y))
  ][, Percent := observations / N][, `:=`(MOE = as.character(round(
    moedeff_calc(pct = Percent, deff = ..deff, n = unweighted_n, zscore = 1.96),
    digits = 1
  )))][, `:=`(Percent = as.character(round(Percent * 100, digits = 1)))][, .(get, get.1, get.2, Percent, MOE)]

  lookup_tbl <- df[, eval(y) := {
    var <- to_factor(get(y), sort_levels = "values")
    var <- fct_explicit_na(var)
    .(var)
  }][, `:=`(valid_total = sum(get(weight)[get(y) != "(Missing)"]))][, .(Percent = round((sum(get(weight)) / first(valid_total) * 100), digits = 1)),
    keyby = .(get(y))
  ][eval(y) != "(Missing)"]
  lookup <- lookup_tbl$Percent
  names(lookup) <- lookup_tbl$get

  xtab_3way[, `Survey Total Percent` := lookup[get.2]]

  setattr(xtab_3way, "names", c(z, x, y, "Percent", "MOE", "Survey Total Percent"))

  xtab_3way
}
