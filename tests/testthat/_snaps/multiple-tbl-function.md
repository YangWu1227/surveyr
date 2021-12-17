# Invalid input for 'l' (list)

    Code
      generate_tbls(l = list(list_topline), df = df, weight = "weightvec", type = "topline",
      output = "word")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list(list_xtab), df = df, weight = "weightvec", type = "crosstab",
      output = "latex")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'df' (list)

    Code
      generate_tbls(l = list_topline, df = list(df), weight = "weightvec", type = "topline",
      output = "word")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      generate_tbls(l = list_xtab, df = list(df), weight = "weightvec", type = "crosstab",
      output = "latex")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'weight' (correct type but incorrect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "var_do_not_exist", type = "topline",
        output = "word")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "var_do_not_exist", type = "crosstab",
        output = "latex")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

# invalid input for 'weight' (no quotes around 'weight' variable but correct value)

    Code
      generate_tbls(l = list_topline, df = df, weight = weightvec, type = "topline",
        output = "word")
    Error <simpleError>
      Please place quotes around the argument 'weight'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = weightvec, type = "crosstab",
        output = "latex")
    Error <simpleError>
      Please place quotes around the argument 'weight'

# Invalid input for 'type' (wrong type)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = FALSE,
        output = "latex")
    Error <simpleError>
      The argument 'type' must be a length-one character vector

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = 3, output = "word")
    Error <simpleError>
      The argument 'type' must be a length-one character vector

# Invalid input for 'type' (incorect value)

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "incorrect",
        output = "word")
    Error <simpleError>
      The argument 'type' must either be 'crosstab' or 'topline'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = crosstab,
        output = "latex")
    Error <simpleError>
      The argument 'type' must be a length-one character vector

# Invalid input for 'output' (wrong type)

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "topline",
        output = 3)
    Error <simpleError>
      The argument 'output' must be a length-one character vector

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "crosstab",
        output = TRUE)
    Error <simpleError>
      The argument 'output' must be a length-one character vector

# Invalid input for 'output' (correct type but incorrect value)

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "topline",
        output = "should_be_word_or_latex")
    Error <simpleError>
      The argument 'output' must either be 'word' or 'latex'

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "crosstab",
        output = word)
    Error <simpleError>
      The argument 'output' must be a length-one character vector

# Mismatched 'type' argument and 'l' list argument

    Code
      generate_tbls(l = list_topline, df = df, weight = "weightvec", type = "crosstab",
        output = "word")
    Error <simpleError>
      argument "y" is missing, with no default

---

    Code
      generate_tbls(l = list_xtab, df = df, weight = "weightvec", type = "topline",
        output = "latex")
    Error <simpleError>
      unused argument (y = .l[[2]][[i]])

