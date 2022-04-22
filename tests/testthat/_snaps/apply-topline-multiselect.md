# apply_topline_multiselect() returns meaningful errors

    Code
      apply_topline_multiselect(list_df = list(list_df[[1]], 3), weight = "weightvec",
      caption = captions, parent = parents)
    Condition
      Error:
      ! The argument 'list_df' must be a list of data frames

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = 3, caption = captions,
        parent = parents)
    Condition
      Error:
      ! The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = "weightvec", caption = 3,
        parent = parents)
    Condition
      Error:
      ! The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

---

    Code
      apply_topline_multiselect(list_df = list_df, weight = "weightvec", caption = captions,
        parent = c("wrong_type", "not_boolean"))
    Condition
      Error:
      ! The arguments 'weight', 'caption', and 'parent' must be a character, a list, and a logical vector, respectively

# Test that topline_caption_multiselect() return helpful errors

    Code
      topline_caption_multiselect(patterns = c(1, 2, 3, 4), parent = parents)
    Condition
      Error:
      ! The arguments 'patterns' and 'parent' must be a character vector and a logical vector, respectively

---

    Code
      topline_caption_multiselect(patterns = patterns, parent = c("TRUE", "FALSE",
        "TRUE", "TRUE"))
    Condition
      Error:
      ! The arguments 'patterns' and 'parent' must be a character vector and a logical vector, respectively

---

    Code
      topline_caption_multiselect(patterns = patterns, parent = c(parents, TRUE))
    Condition
      Error:
      ! The arguments 'patterns' and 'parent' must have equal lengths

