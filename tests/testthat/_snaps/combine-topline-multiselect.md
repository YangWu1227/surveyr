# combine_topline_multiselect() provides meaningful error messages

    Code
      combine_topline_multiselect(c(3, 5, 6))
    Condition
      Error:
      ! 'l' must be the output of `apply_topline_multiselect()`

---

    Code
      combine_topline_multiselect(list(test = c(3, 4), error = ("test")))
    Condition
      Error:
      ! 'l' must be the output of `apply_topline_multiselect()`

