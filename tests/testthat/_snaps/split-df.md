# split_df() returns meaningful error messages

    Code
      split_df(list(c("Wrong_input")), patterns, "weightvec")
    Condition
      Error:
      ! The arguments 'df', 'patterns', and 'weight' must be data frame object and character vectors, respectively

---

    Code
      split_df(df, c(3, 4, 99), "weightvec")
    Condition
      Error:
      ! The arguments 'df', 'patterns', and 'weight' must be data frame object and character vectors, respectively

---

    Code
      split_df(df, patterns, weightvec)
    Condition
      Error in `split_df()`:
      ! object 'weightvec' not found

---

    Code
      split_df(df, patterns, "does_not_exist")
    Condition
      Error:
      ! The argument 'weight' must exist in 'df'

