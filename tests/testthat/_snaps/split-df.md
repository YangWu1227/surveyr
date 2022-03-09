# split_df() returns meaningful wrong type error messages

    Code
      split_df(list(c("Wrong_input")), patterns, "weightvec")
    Error <simpleError>
      The arguments 'df', 'patterns', and 'weight' must be data frame object and character vectors, respectively

---

    Code
      split_df(df, c(3, 4, 99), "weightvec")
    Error <simpleError>
      The arguments 'df', 'patterns', and 'weight' must be data frame object and character vectors, respectively

---

    Code
      split_df(df, patterns, weightvec)
    Error <simpleError>
      object 'weightvec' not found

---

    Code
      split_df(df, patterns, "does_not_exist")
    Error <simpleError>
      The argument 'weight' must exist in 'df'

