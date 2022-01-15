# Invalid input for 'df'

    Code
      generate_xtab_args(df = c(3, 4), var_of_interest = "party_reg", rm = "weightvec")
    Error <simpleError>
      'df' must be a data frame

---

    Code
      generate_xtab_3way_args(df = c(3, 4), control_var = "party_reg",
      independent_vars = c("education_rollup", "issue_focus"), dependent_vars = c(
        "issue_focus", "education_rollup"))
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

# Invalid input for 'control_var' wrong type, length, and value

    Code
      generate_xtab_3way_args(df = df, control_var = complex(3), independent_vars = c(
        "education_rollup", "issue_focus"), dependent_vars = c("issue_focus",
        "education_rollup"))
    Error <simpleError>
      The argument 'control_var' must be a single column name found in 'df'

---

    Code
      generate_xtab_3way_args(df = df, control_var = c("party_reg", "party_reg"),
      independent_vars = c("education_rollup", "issue_focus"), dependent_vars = c(
        "issue_focus", "education_rollup"))
    Error <simpleError>
      The argument 'control_var' must be a single column name found in 'df'

---

    Code
      generate_xtab_3way_args(df = df, control_var = "does_not_exist",
        independent_vars = c("education_rollup", "issue_focus"), dependent_vars = c(
          "issue_focus", "education_rollup"))
    Error <simpleError>
      The argument 'control_var' must be a single column name found in 'df'

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

# Invalid input for 'dependent_var' for two-way crosstabs

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

# Invalid inputs for 'independent_var' and 'dependent_var' for three-way crosstabs

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        3), dependent_vars = c("issue_focus", "education_rollup"))
    Error <simpleError>
      The argument 'independent_vars' must be a character vector with length no greater than (length(df) - 1)

---

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        "issue_focus", "education_rollup", "issue_focus", "education_rollup"),
      dependent_vars = c("issue_focus", "education_rollup"))
    Error <simpleError>
      The argument 'independent_vars' must be a character vector with length no greater than (length(df) - 1)

---

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        "not", "exist", "issue_focus"), dependent_vars = c("issue_focus",
        "education_rollup"))
    Error <simpleError>
      The argument 'independent_vars' must be a subset of `base::setdiff(x = names(df), y = control_var)`

---

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        "issue_focus", "education_rollup"), dependent_vars = c(3))
    Error <simpleError>
      The argument 'dependent_vars' must be a character vector with length no greater than (length(df) - 1)

---

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        "issue_focus", "education_rollup"), dependent_vars = c("issue_focus",
        "education_rollup", "issue_focus", "education_rollup"))
    Error <simpleError>
      The argument 'dependent_vars' must be a character vector with length no greater than (length(df) - 1)

---

    Code
      generate_xtab_3way_args(df = df, control_var = "party_reg", independent_vars = c(
        "issue_focus", "education_rollup"), dependent_vars = c("not", "exist",
        "issue_focus"))
    Error <simpleError>
      The argument 'dependent_vars' must be a subset of `base::setdiff(x = names(df), y = control_var)`

