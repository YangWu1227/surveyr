# Invalid input for 'l' (list)

    Code
      ft_generate_tbls(l = list(topline_args), df = df, weight = "weightvec", type = "topline")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = list(xtab_args), df = df, weight = "weightvec", type = "crosstab_2way")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = list(xtab_3way_args), df = df, weight = "weightvec", type = "crosstab_3way")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'df' (list)

    Code
      ft_generate_tbls(l = topline_args, df = list(df), weight = "weightvec", type = "topline")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = xtab_args, df = list(df), weight = "weightvec", type = "crosstab_2way")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = list(df), weight = "weightvec", type = "crosstab_3way")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'weight' (correct type but incorrect value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "var_do_not_exist", type = "topline")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "var_do_not_exist", type = "crosstab_2way")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = df, weight = "var_do_not_exist",
        type = "crosstab_3way")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

# invalid input for 'weight' (no quotes around 'weight' variable but correct value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = weightvec, type = "topline")
    Error <simpleError>
      Please place quotes around the argument 'weight'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = weightvec, type = "crosstab_2way")
    Error <simpleError>
      Please place quotes around the argument 'weight'

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = df, weight = weightvec, type = "crosstab_3way")
    Error <simpleError>
      Please place quotes around the argument 'weight'

# Invalid input for 'type' (wrong type)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = FALSE)
    Error <simpleError>
      The argument 'type' must be a length-one character vector

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = 3)
    Error <simpleError>
      The argument 'type' must be a length-one character vector

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = df, weight = "weightvec", type = 1:2 +
        0+1i * (8:9))
    Error <simpleError>
      The argument 'type' must be a length-one character vector

# Invalid input for 'type' (incorect value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = "incorrect")
    Error <simpleError>
      The argument 'type' must either be 'crosstab', 'crosstab_3way', 'topline'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = crosstab_2way)
    Error <simpleError>
      Please place quotes around the argument 'type'

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = df, weight = "weightvec", type = "crosstab_3wayy")
    Error <simpleError>
      The argument 'type' must either be 'crosstab', 'crosstab_3way', 'topline'

# Mismatched 'type' argument and 'l' list argument

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = "crosstab_2way")
    Error <simpleError>
      argument "y" is missing, with no default

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "topline")
    Error <simpleError>
      unused argument (y = .l[[2]][[i]])

---

    Code
      ft_generate_tbls(l = xtab_3way_args, df = df, weight = "weightvec", type = "crosstab_2way")
    Error <simpleError>
      unused argument (z = .l[[3]][[i]])

