# Invalid input for 'l' (list)

    Code
      ft_generate_tbls(l = list(topline_args), df = df, weight = "weightvec", type = "topline",
      output = "word")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = list(xtab_args), df = df, weight = "weightvec", type = "crosstab",
      output = "latex")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'df' (list)

    Code
      ft_generate_tbls(l = topline_args, df = list(df), weight = "weightvec", type = "topline",
      output = "word")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

---

    Code
      ft_generate_tbls(l = xtab_args, df = list(df), weight = "weightvec", type = "crosstab",
      output = "latex")
    Error <simpleError>
      The argument 'l' and 'df' must be objects inheriting from data frame

# Invalid input for 'weight' (correct type but incorrect value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "var_do_not_exist", type = "topline",
        output = "word")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "var_do_not_exist", type = "crosstab",
        output = "latex")
    Error <simpleError>
      The argument 'weight' must be a single column name found in 'df'

# invalid input for 'weight' (no quotes around 'weight' variable but correct value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = weightvec, type = "topline",
        output = "word")
    Error <simpleError>
      Please place quotes around the argument 'weight'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = weightvec, type = "crosstab",
        output = "latex")
    Error <simpleError>
      Please place quotes around the argument 'weight'

# Invalid input for 'type' (wrong type)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = FALSE,
        output = "latex")
    Error <simpleError>
      The argument 'type' must be a length-one character vector

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = 3,
        output = "word")
    Error <simpleError>
      The argument 'type' must be a length-one character vector

# Invalid input for 'type' (incorect value)

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = "incorrect",
        output = "word")
    Error <simpleError>
      The argument 'type' must either be 'crosstab' or 'topline'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = crosstab,
        output = "latex")
    Error <simpleError>
      Please place quotes around the argument 'type'

# Invalid input for 'output' (wrong type)

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "topline",
        output = 3)
    Error <simpleError>
      The argument 'output' must be a length-one character vector

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "crosstab",
        output = TRUE)
    Error <simpleError>
      The argument 'output' must be a length-one character vector

# Invalid input for 'output' (correct type but incorrect value)

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "topline",
        output = "should_be_word_or_latex")
    Error <simpleError>
      The argument 'output' must either be 'word' or 'latex'

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "crosstab",
        output = word)
    Error <simpleError>
      Please place quotes around the argument 'output'

# Mismatched 'type' argument and 'l' list argument

    Code
      ft_generate_tbls(l = topline_args, df = df, weight = "weightvec", type = "crosstab",
        output = "word")
    Error <simpleError>
      argument "y" is missing, with no default

---

    Code
      ft_generate_tbls(l = xtab_args, df = df, weight = "weightvec", type = "topline",
        output = "latex")
    Error <simpleError>
      unused argument (y = .l[[2]][[i]])

