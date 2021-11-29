# generate_xtab() provides meaningful error messages

    Code
      generate_xtab(df = list("2", body(dplyr::mutate)), x = "education_rollup", y = "party_reg",
      weight = "weightvec", caption = "caption")
    Error <simpleError>
      The argument 'df' must be an object of class or subclass of data frame

---

    Code
      generate_xtab(df = df, x = "education_rollup", y = "party_reg", weight = "weightvec",
        caption = 3)
    Error <simpleError>
      The argument 'caption' must be a length one character vector

---

    Code
      generate_xtab(df = df, x = "education_rollup", y = "party_reg", weight = "weightvec",
        caption = c("caption1", "caption2"))
    Error <simpleError>
      The argument 'caption' must be a length one character vector

---

    Code
      generate_xtab(df = df, x = 3, y = "party_reg", weight = "weightvec", caption = "caption")
    Error <simpleError>
      The arguments 'x', 'y', and 'weight' must be character vectors of length one

---

    Code
      generate_xtab(df = df, x = c("education_rollup", "party_reg"), y = "party_reg",
      weight = "weightvec", caption = "caption")
    Error <simpleError>
      The arguments 'x', 'y', and 'weight' must be character vectors of length one

---

    Code
      generate_xtab(df = df, x = "party_reg", y = TRUE, weight = "weightvec",
        caption = "caption")
    Error <simpleError>
      The arguments 'x', 'y', and 'weight' must be character vectors of length one

# generate_topline provides meaningful error messages

    Code
      generate_topline(df = list("2", body(dplyr::mutate)), x = "education_rollup",
      weight = "weightvec", caption = "caption")
    Error <simpleError>
      The argument 'df' must be an object of class or subclass of data frame

---

    Code
      generate_topline(df = df, x = "education_rollup", weight = "weightvec",
        caption = 3)
    Error <simpleError>
      The argument 'caption' must be a length one character vector

---

    Code
      generate_topline(df = df, x = "education_rollup", weight = "weightvec",
        caption = c("caption1", "caption2"))
    Error <simpleError>
      The argument 'caption' must be a length one character vector

---

    Code
      generate_topline(df = df, x = "party_reg", weight = 3, caption = "caption")
    Error <simpleError>
      The arguments 'x' and 'weight' must be character vectors of length one

---

    Code
      generate_topline(df = df, x = c("education_rollup", "party_reg"), weight = "weightvec",
      caption = "caption")
    Error <simpleError>
      The arguments 'x' and 'weight' must be character vectors of length one

---

    Code
      generate_topline(df = df, x = TRUE, weight = "weightvec", caption = "caption")
    Error <simpleError>
      The arguments 'x' and 'weight' must be character vectors of length one

