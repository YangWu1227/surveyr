# generate_topline_multiselect() returns helpful errors

    Code
      generate_topline_multiselect(df = c(3, 4), weight = "weightvec", caption = c(
        "caption1", "caption2"), parent = TRUE)
    Error <simpleError>
      The argument 'df' must be an object of class or subclass of data frame

---

    Code
      generate_topline_multiselect(df = c(3, 4), weight = "weightvec", caption = "caption",
      parent = FALSE)
    Error <simpleError>
      The argument 'df' must be an object of class or subclass of data frame

