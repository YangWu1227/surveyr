# list_xtab_args() provides meaningful error messages

    Code
      list_xtab_args(df = df, var_of_interest = c(3, 4, 1))
    Error <simpleError>
      'var_of_intereset' must be a character vector

---

    Code
      list_xtab_args(df = df, var_of_interest = c("education_rollup", "party_reg",
        "issue_focus"), dependent_vars = c(3, 4, 5))
    Error <simpleError>
      'dependent_vars' must be a list object

# flatten_args() provides meaningful error messages

    Code
      flatten_args(c(3, 5, 6))
    Error <simpleError>
      'l' must be the output of `list-xtab_args()`

---

    Code
      flatten_args(list(test = c(3, 4), error = ("test")))
    Error <simpleError>
      'l' must be the output of `list-xtab_args()`

