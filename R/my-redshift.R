#' A class for interacting with Redshift
#'
#' @description
#' This class can be used to interact with a Redshift database, including reading tables and query results into R.
#'
#' @importFrom R6 R6Class
#' @importFrom DBI dbConnect dbGetQuery
#' @importFrom RPostgres Redshift
#' @importFrom rlang is_integer
#'
#' @export
MyRedshift <- R6Class("MyRedshift",
  public = list(
    #' @field host Database host address.
    host = NULL,

    #' @field port Connection port number.
    port = NULL,

    #' @field user User name used to authenticate.
    user = NULL,

    #' @field password Database password.
    password = NULL,

    #' @field dbname Database name.
    dbname = NULL,

    #' @description
    #' Instantiate a new `MyRedshift` object.
    #'
    #' @param host Database host address.
    #' @param port Connection port number.
    #' @param user User name used to authenticate.
    #' @param password Database password.
    #' @param dbname Database name.
    #'
    #' @return A new `MyRedshift` object.
    initialize = function(host = NA, port = NA, user = NA, password = NA, dbname = NA) {
      if (!all(
        c(
          is_character(host, n = 1), is_character(port, n = 1), is_character(user, n = 1),
          is_character(password, n = 1), is_character(dbname, n = 1)
        )
      )) {
        stop("Database parameters must all be length-1 character vectors", call. = FALSE)
      }

      self$host <- host
      self$port <- port
      self$user <- user
      self$password <- password
      self$dbname <- dbname
    },

    #' @description
    #' A method for reading a table into a DataFrame. Warning: Reading large tables
    #' all at once may lead to memory issues. If the argument `n` is omitted, entire table will be returned.
    #' A value of `Inf` for the `n` argument is supported and also returns the full result. If more rows than
    #' available are fetched (by passing a value for `n` that is too large), the result is returned in full without warning.
    #' If zero rows are requested, the columns of the data frame are still fully typed. Fetching fewer rows
    #' than available is permitted, no warning is issued.
    #'
    #' @param table_name Table name.
    #' @param nrow Number of rows to be fetched.
    #'
    #' @return A DataFrame representing a table in the database.
    read_tbl = function(table_name, nrow = -1) {
      if (!is_character(table_name, n = 1) | !is_integer(nrow, n = 1)) {
        stop("The arguments 'table_name' and 'nrow' must be a length-1 character vector and a length-1 integer vector, respectively", call. = FALSE)
      }

      # Create connection
      conn <- dbConnect(
        drv = Redshift(),
        host = self$host,
        port = self$port,
        user = self$user,
        password = self$password,
        dbname = self$dbname
      )

      sql <- glue(
        "SELECT * FROM {table_name};"
      )

      # Read table as a data frame
      df <- dbGetQuery(conn, statement = sql, n = nrow)

      df
    }
  )
)
