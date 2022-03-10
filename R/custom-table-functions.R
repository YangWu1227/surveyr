# The current implementation avoids lazy evaluation
# The preferred approach will be to use data.table::substitute2, which will be release in version 1.14.3

# Custom topline ----------------------------------------------------------

#' @importFrom labelled to_factor
#' @importFrom forcats fct_explicit_na
topline_internal <- function(df, variable, weight) {
  if (!all(c(variable, weight) %chin% names(df))) {
    stop("The arguments variable and weight must be found amongst names(df)", call. = FALSE)
  }

  # Coerce (creates a copy)
  df <- as.data.table(df)

  # Rename columns to avoid lazy evaluation until data.table version 1.14.3 is released
  setnames(df, c(variable, weight), c("variable", "weight"))

  # To prevent R CMD check notes
  `.` <- valid_total <- Response <- NULL

  topline <- df[, variable := {
    var <- to_factor(variable, sort_levels = levels)
    var <- fct_explicit_na(var)
    .(var)
  }][, valid_total := .(sumcpp(weight[variable != "(Missing)"]))][, .(
    Frequency = round(sumcpp(weight), digits = 0),
    Percent = round((sumcpp(weight) / first(valid_total) * 100), digits = 1)
  ),
  keyby = .(variable)
  ][variable != "(Missing)"]

  setnames(topline, c("variable", "Frequency", "Percent"), c("Response", "Frequency", "Percent"))

  topline <- rbindlist(list(topline, data.table(
    Response = "Total",
    Frequency = sum(topline$Frequency),
    Percent = sum(topline$Percent)
  )))[, Response := as.character(Response)]

  topline
}

# Custom two-way crosstab -------------------------------------------------

moe_crosstab_internal <- function(df, x, y, weight) {
  if (!all(c(x, y, weight) %chin% names(df))) {
    stop("The arguments x, y, weight must be found amongst names(df)", call. = FALSE)
  }

  # Coerce (creates a copy)
  df <- as.data.table(df)

  # Rename columns to avoid lazy evaluation until data.table version 1.14.3 is released
  setnames(df, c(x, y, weight), c("x", "y", "weight"))

  # To prevent R CMD check notes
  `.` <- valid_total <- total <- unweighted_n <- Percent <- N <- `..deff` <- `get.1` <- MOE <- `Survey Total Percent` <- observations <- NULL

  # Design effect
  deff <- design_effect(df[, weight])

  # Xtab
  xtab <- df[!is.na(x) & !is.na(y)][, c(x, y) := .(
    to_factor(x),
    to_factor(y)
  )][, c("total", "unweighted_n") := .(
    sum(weight),
    length(weight)
  ), by = x][, .(
    observations = sumcpp(weight),
    N = first(total),
    unweighted_n = first(unweighted_n)
  ),
  keyby = .(x, y)
  ][, Percent := observations / N][, `:=`(MOE = as.character(round(
    moe_design_effect(Percent, ..deff, unweighted_n, zscore = 1.96),
    digits = 1
  )))][, `:=`(Percent = as.character(round(Percent * 100, digits = 1)))][, .(x, y, Percent, MOE)]

  # Lookup table to add "Survey Total Percent" column
  lookup_tbl <- df[, y := {
    var <- to_factor(y, sort_levels = "values")
    var <- fct_explicit_na(var)
    .(var)
  }][, `:=`(valid_total = sumcpp(weight[y != "(Missing)"]))][, .(Percent = round((sumcpp(weight) / first(valid_total) * 100), digits = 1)),
    keyby = .(y)
  ][y != "(Missing)"]
  lookup <- lookup_tbl$Percent
  names(lookup) <- lookup_tbl$y

  xtab[, `Survey Total Percent` := as.character(lookup[y])]

  setnames(xtab, c("x", "y"), c(x, y))

  xtab
}

# Custom three-way crosstab -----------------------------------------------

moe_crosstab_3way_internal <- function(df, x, y, z, weight) {
  if (!all(c(x, y, z, weight) %chin% names(df))) {
    stop("The arguments x, y, z, weight must be found amongst names(df)", call. = FALSE)
  }

  # Coerce (creates a copy)
  df <- as.data.table(df)

  # Rename columns to avoid lazy evaluation until data.table version 1.14.3 is released
  setnames(df, c(x, y, z, weight), c("x", "y", "z", "weight"))

  # To prevent R CMD check notes
  `.` <- valid_total <- total <- unweighted_n <- Percent <- N <- `..deff` <- `get.1` <- `get.2` <- MOE <- `Survey Total Percent` <- observations <- NULL

  # Design effect
  deff <- design_effect(df[, weight])

  xtab_3way <- df[!is.na(x) & !is.na(y) & !is.na(z)][, c(x, y, z) := .(
    to_factor(x),
    to_factor(y),
    to_factor(z)
  )][, c("total", "unweighted_n") := .(
    sum(weight),
    length(weight)
  ), by = .(z, x)][, .(
    observations = sum(weight),
    N = first(total),
    unweighted_n = first(unweighted_n)
  ),
  keyby = .(z, x, y)
  ][, Percent := observations / N][, `:=`(MOE = as.character(round(
    moe_design_effect(Percent, ..deff, unweighted_n, zscore = 1.96),
    digits = 1
  )))][, `:=`(Percent = as.character(round(Percent * 100, digits = 1)))][, .(z, x, y, Percent, MOE)]

  lookup_tbl <- df[, y := {
    var <- to_factor(y, sort_levels = "values")
    var <- fct_explicit_na(var)
    .(var)
  }][, `:=`(valid_total = sumcpp(weight[y != "(Missing)"]))][, .(Percent = round((sumcpp(weight) / first(valid_total) * 100), digits = 1)),
    keyby = .(y)
  ][y != "(Missing)"]
  lookup <- lookup_tbl$Percent
  names(lookup) <- lookup_tbl$y

  xtab_3way[, `Survey Total Percent` := lookup[y]]

  setnames(xtab_3way, c("z", "x", "y"), c(z, x, y))

  xtab_3way
}


# Design effect  ----------------------------------------------------------

# Formula taken from https://www.pewresearch.org/internet/2010/04/27/methodology-85/
design_effect <- function(weight) {
  (length(weight) * sum(weight^2)) / (sum(weight)^2)
}

# Formula taken from https://www.pewresearch.org/internet/2010/04/27/methodology-85/
moe_design_effect <- function(percent, deff, n, zscore = 1.96) {
  sqrt(deff) * zscore * sqrt((percent * (1 - percent)) / (n - 1)) * 100
}
