# rm_spl_char() provides meaningful error messages

    Code
      rm_spl_char(df = c(3, 4), var = c("col_1"))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      rm_spl_char(df = list(3, body(dplyr::mutate)), var = c("col_1"))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      rm_spl_char(df = matrix(1:4, nrow = 2), var = c("col_1"))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      rm_spl_char(df = as.data.frame(matrix(1:4, nrow = 2)), var = c(3))
    Condition
      Error:
      ! 'var' must be a character vector no greater than `length(df)`

---

    Code
      rm_spl_char(df = as.data.frame(matrix(1:4, ncol = 1)), var = c("V1", "V2"))
    Condition
      Error:
      ! 'var' must be a character vector no greater than `length(df)`

---

    Code
      rm_spl_char(df = as.data.frame(matrix(1:4, ncol = 2)), var = c("V1", "V9"))
    Condition
      Error:
      ! 'var' must be columns found in 'df'

# col_nms_to_title() provides meaningful error messages

    Code
      col_nms_to_title(df = c(3, 4))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      col_nms_to_title(df = list(3, body(dplyr::mutate)))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      col_nms_to_title(df = matrix(1:4, nrow = 2))
    Condition
      Error:
      ! 'df' must be a data frame

# col_nms_rm_splchar() provides meaningful error messages

    Code
      col_nms_rm_splchar(df = c(3, 4))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      col_nms_rm_splchar(df = list(3, body(dplyr::mutate)))
    Condition
      Error:
      ! 'df' must be a data frame

---

    Code
      col_nms_rm_splchar(df = matrix(1:4, nrow = 2))
    Condition
      Error:
      ! 'df' must be a data frame

