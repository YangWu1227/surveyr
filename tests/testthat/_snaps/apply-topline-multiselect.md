# apply_topline_multiselect() returns meaningful errors

    Code
      apply_topline_multiselect(list_df = list(list_df[[1]], 3), weight = "weightvec",
      caption = captions, parent = parents)
    Error <simpleError>
      The argument 'list_df' must be a list of data frames

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = 3, caption = captions,
        parent = parents)
    Error <simpleError>
      The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = "weightvec", caption = 3,
        parent = parents)
    Error <simpleError>
      The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = "weightvec", caption = captions,
        parent = c("wrong_type", "not_boolean"))
    Error <simpleError>
      The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

