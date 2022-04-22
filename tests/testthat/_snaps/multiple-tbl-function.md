# Invalid input for 'l' (list)

    Code
      generate_tbls(l = list(list_topline), df = df, weight = "weightvec", type = "topline")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list(list_xtab), df = df, weight = "weightvec", type = "crosstab_2way")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list(list_xtab_3way), df = df, weight = "weightvec", type = "crosstab_3way")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'df' (list)

    Code
      generate_tbls(l = list_topline, df = list(df), weight = "weightvec", type = "topline")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list_xtab, df = list(df), weight = "weightvec", type = "crosstab_2way")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list_xtab_3way, df = list(df), weight = "weightvec", type = "crosstab_3way")
    Condition
      Error:
      ! The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'weight' (correct type but incorrect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "var_do_not_exist", type = "topline")
    Condition
      Error:
      ! The argument 'weight' must be a single column name found in 'df'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "var_do_not_exist", type = "crosstab_2way")
    Condition
      Error:
      ! The argument 'weight' must be a single column name found in 'df'

---

    Code
      generate_tbls(l = list_xtab_3way, df = df, weight = "var_do_not_exist", type = "crosstab_3way")
    Condition
      Error:
      ! The argument 'weight' must be a single column name found in 'df'

# invalid input for 'weight' (no quotes around 'weight' variable but correct value)

    Code
      generate_tbls(l = list_topline, df = df, weight = weightvec, type = "topline")
    Condition
      Error:
      ! Please place quotes around the argument 'weight'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = weightvec, type = "crosstab_2way")
    Condition
      Error:
      ! Please place quotes around the argument 'weight'

---

    Code
      generate_tbls(l = list_xtab_3way, df = df, weight = weightvec, type = "crosstab_3way")
    Condition
      Error:
      ! Please place quotes around the argument 'weight'

# Invalid input for 'type' (wrong type)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = FALSE)
    Condition
      Error:
      ! The argument 'type' must be a length-one character vector

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = 3)
    Condition
      Error:
      ! The argument 'type' must be a length-one character vector

---

    Code
      generate_tbls(l = list_xtab_3way, df = df, weight = "weightvec", type = 1:2 +
        0+1i * (8:9))
    Condition
      Error:
      ! The argument 'type' must be a length-one character vector

# Invalid input for 'type' (incorect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "incorrect")
    Condition
      Error:
      ! The argument 'type' must either be 'crosstab_2way', 'crosstab_3way', 'topline'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = crosstab_2way)
    Condition
      Error:
      ! Please place quotes around the argument 'type'

---

    Code
      generate_tbls(l = list_xtab_3way, df = df, weight = "weightvec", type = "crosstab_3wayy")
    Condition
      Error:
      ! The argument 'type' must either be 'crosstab_2way', 'crosstab_3way', 'topline'

# Mismatched 'type' argument and 'l' list argument

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "crosstab_2way")
    Condition
      Error in `is_character()`:
      ! argument "y" is missing, with no default

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "topline")
    Condition
      Error in `.f()`:
      ! unused argument (y = .l[[2]][[i]])

---

    Code
      generate_tbls(l = list_xtab_3way, df = df, weight = "weightvec", type = "crosstab_2way")
    Condition
      Error in `.f()`:
      ! unused argument (z = .l[[3]][[i]])

