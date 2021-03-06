% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_arguments.R
\name{generate_xtab_args}
\alias{generate_xtab_args}
\title{Generate a list of two-way crosstab arguments}
\usage{
generate_xtab_args(df, var_of_interest, dependent_vars = NULL, rm = NULL)
}
\arguments{
\item{df}{A data frame or tibble.}

\item{var_of_interest}{A single string of the variable of interest.}

\item{dependent_vars}{A character vector of dependent variables. Defaults to crossing \code{var_of_interest}
with all other variables in \code{df} unless \code{rm} is \code{NULL}.}

\item{rm}{A character vector of variables to be removed from consideration. Defaults to \code{NULL}.}
}
\value{
A list of arguments. If n tables were to be generated, this is a \code{tibble} with dimensions (n, 3).
}
\description{
This function is helper for \code{generate_tbls()} or \code{ft_generate_tbls()}. It automatically generates a list of arguments to be
passed on to \code{generate_tbls()} or \code{ft_generate_tbls()} for a given set of arguments. This may be useful when the number of
variables in a data frame is large, and there is a need to generate varying arguments efficiently.
}
\examples{
\donttest{
# Generate list of arguments
generate_xtab_args(df, "var_of_interest")

# Specified dependent variables and removal variables
dependent_vars <- c("col1", "col2")
rm <- c("col19", "col20")
generate_xtab_args(df, "var_of_interest", dependent_vars, rm)
}
}
\seealso{
\code{\link[=generate_tbls]{generate_tbls()}} or \link{ft_generate_tbls} for an example of a list of arguments.
}
