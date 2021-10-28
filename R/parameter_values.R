#' Returns examples of data field values
#'
#' @param data_set a character vector specifying the data set
#' @param data_field a character vector specifying the data field
#'
#' @return returns a data frame with the unique data field values conatained in the first 1000 records of the full data set
#' @export
#'
#' @examples
#' parameter_values(data_set = "fimaNfipClaims", data_field = "totalBuildingInsuranceCoverage")
parameter_values <- function(data_set = NULL, data_field = NULL) {
  data <- open_fema(data_set = data_set, top_n = 999, select = data_field, ask_before_call = F)
  values <- unique(data[, data_field])

  # convert everything to a character to avoid returning factors
  values <- as.character(values)

  return(values)
}
