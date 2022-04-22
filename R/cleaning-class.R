#' A class for cleaning a data frame object
#'
#' @description
#' This class contains common cleaning routines for data frame objects. The input data frame
#' may be one of `data.frame`, `tibble`, or `data.table`, but the output data frame will be
#' a `data.table` object. If needed, an object of the original class can be returned by
#' calling the `restore()` method, which returns a copy of the modified data frame with
#' the original `class` attribute.
#'
#' @importFrom vctrs vec_ptype vec_restore
#'
#' @export
FrameCleaner <- R6Class("FrameCleaner",
  portable = FALSE,
  class = FALSE,
  cloneable = FALSE,
  public = list(
    #' @field df An object that inherits from `data.frame`.
    df = NULL,

    #' @field col_nms Column names of the input `df`.
    col_nms = NULL,

    #' @field ptype A 0-observation slice of the input `df`.
    ptype = NULL,

    #' @description
    #' Instantiate a new `FrameCleaner` object.
    #'
    #' @param df An object that inherits from `data.frame`.
    #'
    #' @return A new `FrameCleaner` object.
    initialize = function(df) {

      if (!inherits(x = df, what = "data.frame", which = FALSE)) {
        stop("The field 'df' must be an object that inherits from data.frame", call. = FALSE)
      }

      # Store prototype as an field
      self$ptype <- vec_ptype(df)

      # Coerce input to data.table by reference
      setDT(df)

      # Fields
      self$df <- df
      self$col_nms <- names(df)
    },

    #' @description
    #' A method for removing leading and trailing white spaces, including
    #' space (`' '`), form feed (`\f`), line feed (`\n`), carriage return (`\r'`,
    #' horizontal tab (`\t`), and vertical tab (`\v`) from column names.
    #' The function modifies the `df` field in-place.
    #'
    #' @return `self`
    col_nms_trim = function() {
      setattr(
        x = self$df,
        name = "names",
        value = trimcpp(self$col_nms)
      )
      invisible(self)
    },

    #' @description
    #' A method for restoring the original class attribute of the input data frame.
    #' Note that a copy is returned. The original input `df` is modified in-place
    #' and should remain a `data.table`.
    #'
    #'
    #' @return An object that inherits from `data.frame`.
    restore = function() {
      vec_restore(x = df, to = self$ptype)
    }
  )
)
