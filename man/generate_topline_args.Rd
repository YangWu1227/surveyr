% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_arguments.R
\name{generate_topline_args}
\alias{generate_topline_args}
\title{Generate a list of topline arguments}
\usage{
generate_topline_args(df, var_of_interest = NULL, rm = NULL)
}
\arguments{
\item{df}{A data frame or tibble.}

\item{var_of_interest}{A single string of the variable of interest. Defaults to \code{NULL}, which returns
all variables in \code{df} unless \code{rm} is \code{NULL}.}

\item{rm}{A character vector of variables to be removed from consideration. Defaults to \code{NULL}.}
}
\value{
A list of arguments. If n tables were to be generated, this is a \code{tibble} with dimensions (n, 2).
}
\description{
This function is helper for \code{generate_tbls()}. It automatically generates a list of arguments to be
passed on to \code{generate_tbls()} for a given set of arguments. This may be useful when the number of
variables in a data frame is large, and there is a need to generate varying arguments efficiently.
}
\examples{
\donttest{
# Generate list of arguments
generate_topline_args(df, "var_of_interest")

# Specified removal variables
rm <- c("col19", "col20")
generate_topline_args(df, "var_of_interest", rm)
}
}
\seealso{
\code{\link[=generate_tbls]{generate_tbls()}} for an example of a list of arguments.
}
