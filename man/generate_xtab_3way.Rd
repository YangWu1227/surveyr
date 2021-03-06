% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_xtab.R
\name{generate_xtab_3way}
\alias{generate_xtab_3way}
\title{Generate three-way crosstabs}
\usage{
generate_xtab_3way(df, x, y, z, weight, caption)
}
\arguments{
\item{df}{A data frame or tibble.}

\item{x}{A single string of the independent variable.}

\item{y}{A single string of the dependent variable.}

\item{z}{A single string of the control variable.}

\item{weight}{A single string of the weighting variable.}

\item{caption}{A length one character vector used as the caption for the crosstab.}
}
\value{
A list object, which is an object of class \code{flextable}.
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

This function takes a data frame or a tibble object, a few variables, and a string caption, returning
a list object that is an instance of class \code{flextable}. The function implements data masking internally
so users must specify data variables as strings (i.e. use "x", "y", "z", "weight").
}
\examples{
\donttest{
# Generate a crosstab
df \%>\% generate_xtab_3way(df = ., "x_var", "y_var", "z_var", "weight", "Z by X And Y")
}
}
\seealso{
\code{\link[=generate_xtab_word]{generate_xtab_word()}} for two-way crosstabs.
}
