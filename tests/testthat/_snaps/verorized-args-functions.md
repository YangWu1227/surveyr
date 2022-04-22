# list_xtab_args() provides meaningful error messages

    Code
      list_xtab_args(df = df, var_of_interest = c(3, 4, 1))
    Condition
      Error:
      ! 'var_of_interest' must be a character vector

---

    Code
      list_xtab_args(df = df, var_of_interest = c("education_rollup", "party_reg",
        "issue_focus"), dependent_vars = c(3, 4, 5))
    Condition
      Error:
      ! 'dependent_vars' must be a list object

# list_xtab_3way_args() provides meaningful error messages

    Code
      list_xtab_3way_args(df = df, control_var = c(3, 4, 1), dependent_vars = list(c(
        "education_rollup", "party_reg")), independent_vars = list(c("party_reg",
        "education_rollup")))
    Condition
      Error:
      ! 'control_var' must be a character vector

# flatten_args() provides meaningful error messages

    Code
      flatten_args(c(3, 5, 6))
    Condition
      Error:
      ! 'l' must be the output of `list_xtab_args()` or `list_xtab_3way_args()`

---

    Code
      flatten_args(list(test = c(3, 4), error = ("test")))
    Condition
      Error:
      ! 'l' must be the output of `list_xtab_args()` or `list_xtab_3way_args()`

