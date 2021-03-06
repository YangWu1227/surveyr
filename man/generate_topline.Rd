% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_topline.R
\name{generate_topline}
\alias{generate_topline}
\title{Generate toplines}
\usage{
generate_topline(df, x, weight, caption)
}
\arguments{
\item{df}{A data frame or tibble.}

\item{x}{A single string of variable name.}

\item{weight}{A single string of the weighting variable.}

\item{caption}{A length one character vector used as the caption for the topline.}
}
\value{
A list object, which is an object of class \code{flextable}.
}
\description{
This function takes a data frame or a tibble object, a variable of interest, and a string
caption, returning a list object that is an instance of class \code{flextable}. The function
implements data masking internally so users must specify data variables as strings
(i.e. use "x", "weight").
}
\examples{
\donttest{
# Generate a topline
df \%>\% generate_topline(df = ., "x_var", "weight", "X")
}
}
