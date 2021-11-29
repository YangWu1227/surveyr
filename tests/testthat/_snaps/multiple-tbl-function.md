# Invalid input for 'l' (list)

    Code
      generate_tbls(l = list(list_topline), df = df, weight = "weightvec", type = "topline")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list(list_xtab), df = df, weight = "weightvec", type = "crosstab")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'df' (list)

    Code
      generate_tbls(l = list_topline, df = list(df), weight = "weightvec", type = "topline")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list_xtab, df = list(df), weight = "weightvec", type = "crosstab")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'weight' (correct type but incorrect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "var_do_not_exist", type = "topline")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "var_do_not_exist", type = "crosstab")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

# nvalid input for 'weight' (no quotes around 'weight' variable but correct value)

    Code
      generate_tbls(l = list_topline, df = df, weight = weightvec, type = "topline")
    Error <simpleError>
      Please place quotes around the argument 'weight'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = weightvec, type = "crosstab")
    Error <simpleError>
      Please place quotes around the argument 'weight'

# Invalid input for 'type' (wrong type)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = FALSE)
    Error <simpleError>
      The argument 'type' must either be 'topline' or 'crosstab'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = 3)
    Error <simpleError>
      The argument 'type' must either be 'topline' or 'crosstab'

# Invalid input for 'type' (incorect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "incorrect")
    Error <simpleError>
      The argument 'type' must either be 'topline' or 'crosstab'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = crosstab)
    Error <simpleError>
      comparison (1) is possible only for atomic and list types

# Mismatched 'type' argument and 'l' list argument

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "crosstab")
    Error <simpleError>
      argument "y" is missing, with no default

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "topline")
    Error <simpleError>
      unused argument (y = .l[[2]][[i]])

