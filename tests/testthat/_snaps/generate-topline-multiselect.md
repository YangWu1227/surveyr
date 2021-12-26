# generate_topline_multiselect() returns helpful errors

    Code
      generate_topline_multiselect(df = c(3, 4), weight = "weightvec", caption = "caption",
      parent = TRUE)
    Error <simpleError>
      The arguments 'x' and 'weight' must be character vectors of length one

---

    Code
      generate_topline_multiselect(df = c(3, 4), weight = "weightvec", caption = "caption",
      parent = FALSE)
    Error <simpleError>
      non-numeric argument to mathematical function

---

    Code
      generate_topline_multiselect(df = list_df[[1]], weight = 3, caption = "caption",
      parent = FALSE)
    Error <simpleError>
      invalid 'type' (character) of argument

---

    Code
      generate_topline_multiselect(df = list_df[[1]], weight = 3, caption = "caption",
      parent = TRUE)
    Error <simpleError>
      The arguments 'x' and 'weight' must be character vectors of length one

