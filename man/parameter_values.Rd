% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parameter_values.R
\name{parameter_values}
\alias{parameter_values}
\title{Returns examples of data field values along with a description of the data field}
\usage{
parameter_values(data_set = NULL, data_field = NULL, message = TRUE)
}
\arguments{
\item{data_set}{a character vector specifying the data set}

\item{data_field}{a character vector specifying the data field}

\item{message}{a logical value that is TRUE by default. When TRUE, the function
will return information as a console message. When set to FALSE, the function
will return the same information as a tibble.}
}
\value{
returns a consoles message providing a description of the data field and
several example values of the data field within the data set.
}
\description{
Returns examples of data field values along with a description of the data field
}
\examples{
\dontrun{
parameter_values(
  data_set = "fimaNfipClaims",
  data_field = "totalBuildingInsuranceCoverage"
)
}
}
