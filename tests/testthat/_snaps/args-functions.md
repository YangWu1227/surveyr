# Invalid input for 'df'

    Code
      generate_xtab_args(df = c(3, 4), var_of_interest = "party_reg", rm = "weightvec")
    Error <simpleError>
      'df' must be a data frame

---

    Code
      generate_topline_args(df = c(3, 4), var_of_interest = "party_reg", rm = "weightvec")
    Error <simpleError>
      'df' must be a data frame

# Invalid input for 'var_of_interest' (wrong type and length)

    Code
      generate_xtab_args(df = df, var_of_interest = 3, rm = "weightvec")
    Error <simpleError>
      The argument 'var_of_interest' must be a single column name found in 'df'

---

    Code
      generate_topline_args(df = df, var_of_interest = 3, rm = "weightvec")
    Error <simpleError>
      The argument 'var_of_interest' must be a character vector of column names found in 'df' with length no greater than length(df)

---

    Code
      generate_xtab_args(df = df, var_of_interest = c("education_rollup",
        "issue_focus"), rm = "weightvec")
    Error <simpleError>
      The argument 'var_of_interest' must be a single column name found in 'df'

---

    Code
      generate_topline_args(df = df, var_of_interest = c("education_rollup",
        "issue_focus", "issue_focus", "issue_focus", "issue_focus"), rm = "weightvec")
    Error <simpleError>
      The argument 'var_of_interest' must be a character vector of column names found in 'df' with length no greater than length(df)

# Invalid input for 'rm' (incorrect value not found in df)

    Code
      generate_xtab_args(df = df, var_of_interest = "education_rollup", rm = "non_existent_var")
    Error <simpleError>
      The argument 'rm' must contain columns in 'df'

---

    Code
      generate_topline_args(df = df, var_of_interest = "party_reg", rm = "non_existent_var")
    Error <simpleError>
      The argument 'rm' must contain columns in 'df'

# Invalid input for 'rm' (wrong type)

    Code
      generate_xtab_args(df = df, var_of_interest = "education_rollup", rm = 3)
    Error <simpleError>
      The argument 'rm' must be a character vector

---

    Code
      generate_topline_args(df = df, var_of_interest = "party_reg", rm = list("test"))
    Error <simpleError>
      The argument 'rm' must be a character vector

# Invalid input for 'dependent_var'

    Code
      generate_xtab_args(df = df, var_of_interest = "education_rollup",
        dependent_vars = 3, rm = "weightvec")
    Error <simpleError>
      The argument 'dependent_vars' must be a character vector with length no greater than (length(df) - 1)

---

    Code
      generate_xtab_args(df = df, var_of_interest = "education_rollup",
        dependent_vars = c("issue_focus", "party_reg", "weightvec",
          "education_rollup"), rm = NULL)
    Error <simpleError>
      The argument 'dependent_vars' must be a character vector with length no greater than (length(df) - 1)

