#' Returns examples of data field values along with a description of the data field
#'
#' @param data_set a character vector specifying the data set
#' @param data_field a character vector specifying the data field
#' @param message a logical value that is TRUE by default. When TRUE, the function
#' will return information as a console message. When set to FALSE, the function
#' will return the same information as a tibble.
#'
#' @return returns a consoles message providing a description of the data field and
#' several example values of the data field within the data set.
#' @export
#'
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' parameter_values(
#'   data_set = "fimaNfipClaims",
#'   data_field = "totalBuildingInsuranceCoverage"
#' )
#' }
parameter_values <- function(data_set = NULL, data_field = NULL, message = TRUE) {

  # get some example values of the data field
  data <- open_fema(data_set = data_set, top_n = 999, select = data_field, ask_before_call = F)
  values <- unique(data[, data_field])

  # ensure data_set is a valid data set
  data_set <- valid_dataset(data_set)

  # get data set fields
  data <- open_fema(data_set = "datasetfields", ask_before_call = F)

  # filter to users data set
  data <- data[which(trimws(tolower(data$openFemaDataSet)) ==
    trimws(tolower(data_set))), ]

  # filter to users data field
  data <- data[which(trimws(tolower(data$name)) ==
    trimws(tolower(data_field))), ]

  # message
  if (message == TRUE) {
    message(
      "Data Set: ", data_set, "\nData Field: ", data_field,
      "\nData Field Description: ", data$type,
      "\nData Field Example Values: ", head(values),
      "\nMore Information Available at: https://www.fema.gov/about/openfema/data-sets"
    )
  } else {
    (
      return(tibble(
        "Data Set" = data_set, "Data Field" = data_field,
        "Data Field Description" = data$type,
        "Data Field Example Values" = list(head(values))
      ))
    )
  }
}
